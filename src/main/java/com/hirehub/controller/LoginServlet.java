package com.hirehub.controller;

import com.hirehub.dao.CompanyDAO;
import com.hirehub.dao.StudentDAO;
import com.hirehub.dao.UserDAO;
import com.hirehub.model.Company;
import com.hirehub.model.Student;
import com.hirehub.model.User;
import com.hirehub.util.PasswordUtil;
import com.hirehub.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;
    private StudentDAO studentDAO;
    private CompanyDAO companyDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        studentDAO = new StudentDAO();
        companyDAO = new CompanyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectByRole(user, req, resp);
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = ValidationUtil.sanitize(req.getParameter("email"));
        String password = req.getParameter("password");

        if (!ValidationUtil.isValidEmail(email) || password == null || password.isEmpty()) {
            req.setAttribute("errorMessage", "Invalid email or password format.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.findByEmail(email);

        if (user == null) {
            req.setAttribute("errorMessage", "Invalid email or password.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        if ("BLOCKED".equalsIgnoreCase(user.getStatus())) {
            req.setAttribute("errorMessage", "Your account has been blocked by the administrator.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        boolean validPassword = PasswordUtil.verifyPassword(password, user.getSalt(), user.getPasswordHash());

        if (!validPassword) {
            req.setAttribute("errorMessage", "Invalid email or password.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Create HTTP Session
        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);

        if ("STUDENT".equalsIgnoreCase(user.getRole())) {
            Student student = studentDAO.findByUserId(user.getId());
            session.setAttribute("studentProfile", student);
        } else if ("COMPANY".equalsIgnoreCase(user.getRole())) {
            Company company = companyDAO.findByUserId(user.getId());
            session.setAttribute("companyProfile", company);
        }

        redirectByRole(user, req, resp);
    }

    private void redirectByRole(User user, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else if ("STUDENT".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        } else if ("COMPANY".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/company/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
}
