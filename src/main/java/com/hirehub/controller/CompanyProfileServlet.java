package com.hirehub.controller;

import com.hirehub.dao.CompanyDAO;
import com.hirehub.model.Company;
import com.hirehub.model.User;
import com.hirehub.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/company/profile-update")
public class CompanyProfileServlet extends HttpServlet {

    private CompanyDAO companyDAO;

    @Override
    public void init() throws ServletException {
        companyDAO = new CompanyDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        Company company = companyDAO.findByUserId(user.getId());

        if (company == null) {
            resp.sendRedirect(req.getContextPath() + "/company/profile");
            return;
        }

        company.setCompanyName(ValidationUtil.sanitize(req.getParameter("companyName")));
        company.setPhone(ValidationUtil.sanitize(req.getParameter("phone")));
        company.setWebsite(ValidationUtil.sanitize(req.getParameter("website")));
        company.setIndustry(ValidationUtil.sanitize(req.getParameter("industry")));
        company.setCompanySize(ValidationUtil.sanitize(req.getParameter("companySize")));
        company.setLocation(ValidationUtil.sanitize(req.getParameter("location")));
        company.setDescription(ValidationUtil.sanitize(req.getParameter("description")));
        company.setLogoUrl(ValidationUtil.sanitize(req.getParameter("logoUrl")));

        companyDAO.updateCompanyProfile(company);
        session.setAttribute("companyProfile", company);

        resp.sendRedirect(req.getContextPath() + "/company/profile?success=Company+profile+updated+successfully.");
    }
}
