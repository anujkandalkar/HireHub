package com.hirehub.controller;

import com.hirehub.dao.UserDAO;
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

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("reset".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("resetUserId");
                session.removeAttribute("resetRole");
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetPhone");
                session.removeAttribute("resetVerified");
            }
        }
        req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("verify_match".equals(action)) {
            handleVerifyMatch(req, resp);
        } else if ("reset_password".equals(action)) {
            handleResetPassword(req, resp);
        } else {
            req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
        }
    }

    private void handleVerifyMatch(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = req.getParameter("role"); // STUDENT or COMPANY
        String email = ValidationUtil.sanitize(req.getParameter("email"));
        String phone = ValidationUtil.sanitize(req.getParameter("phone"));

        if (role == null || role.trim().isEmpty()) role = "STUDENT";

        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("errorMessage", "Please enter a valid Gmail / Email address.");
            req.setAttribute("step", "1");
            req.setAttribute("selectedRole", role);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (phone == null || phone.trim().replaceAll("[^0-9]", "").isEmpty()) {
            req.setAttribute("errorMessage", "Please enter a valid Mobile Phone Number.");
            req.setAttribute("step", "1");
            req.setAttribute("selectedRole", role);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.findByEmailPhoneAndRole(email, phone, role);

        if (user == null) {
            String roleName = "COMPANY".equalsIgnoreCase(role) ? "Company / Employer" : "Candidate / Student";
            req.setAttribute("errorMessage", "No registered " + roleName + " account found matching both the provided Gmail address and Mobile phone number.");
            req.setAttribute("step", "1");
            req.setAttribute("selectedRole", role);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("resetUserId", user.getId());
        session.setAttribute("resetRole", role);
        session.setAttribute("resetEmail", email);
        session.setAttribute("resetPhone", phone);
        session.setAttribute("resetVerified", true);

        req.setAttribute("successMessage", "Account verified successfully! Please enter your new password below.");
        req.setAttribute("step", "2");
        req.setAttribute("selectedRole", role);
        req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("resetUserId") == null || !Boolean.TRUE.equals(session.getAttribute("resetVerified"))) {
            req.setAttribute("errorMessage", "Session expired or verification incomplete. Please verify your account again.");
            req.setAttribute("step", "1");
            req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
            return;
        }

        int userId = (Integer) session.getAttribute("resetUserId");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (newPassword == null || newPassword.trim().length() < 6) {
            req.setAttribute("errorMessage", "New password must be at least 6 characters long.");
            req.setAttribute("step", "2");
            req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "New password and confirmation password do not match.");
            req.setAttribute("step", "2");
            req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
            return;
        }

        String newSalt = PasswordUtil.generateSalt();
        String newHash = PasswordUtil.hashPassword(newPassword, newSalt);

        boolean updated = userDAO.updatePassword(userId, newHash, newSalt);

        if (updated) {
            session.removeAttribute("resetUserId");
            session.removeAttribute("resetRole");
            session.removeAttribute("resetEmail");
            session.removeAttribute("resetPhone");
            session.removeAttribute("resetVerified");

            req.getSession(true).setAttribute("successMessage", "Password updated successfully! Please log in with your new password.");
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            req.setAttribute("errorMessage", "Database update failed. Please try again.");
            req.setAttribute("step", "2");
            req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
        }
    }
}
