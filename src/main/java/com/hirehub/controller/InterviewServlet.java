package com.hirehub.controller;

import com.hirehub.dao.*;
import com.hirehub.model.*;
import com.hirehub.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

@WebServlet("/schedule-interview")
public class InterviewServlet extends HttpServlet {

    private InterviewDAO interviewDAO;
    private ApplicationDAO applicationDAO;
    private StudentDAO studentDAO;
    private CompanyDAO companyDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        interviewDAO = new InterviewDAO();
        applicationDAO = new ApplicationDAO();
        studentDAO = new StudentDAO();
        companyDAO = new CompanyDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"COMPANY".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Company company = companyDAO.findByUserId(user.getId());
        if (company == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int appId = Integer.parseInt(req.getParameter("applicationId"));
            String dateStr = req.getParameter("interviewDate");
            String timeStr = req.getParameter("interviewTime");
            String type = ValidationUtil.sanitize(req.getParameter("interviewType"));
            String link = ValidationUtil.sanitize(req.getParameter("meetingLink"));
            String interviewer = ValidationUtil.sanitize(req.getParameter("interviewerName"));
            String notes = ValidationUtil.sanitize(req.getParameter("notes"));

            Application app = applicationDAO.findById(appId);
            if (app == null || app.getCompanyId() != company.getId()) {
                resp.sendRedirect(req.getContextPath() + "/company/applications?error=Invalid+application.");
                return;
            }

            Interview interview = new Interview();
            interview.setApplicationId(appId);
            interview.setCompanyId(company.getId());
            interview.setStudentId(app.getStudentId());
            interview.setInterviewDate(Date.valueOf(dateStr.trim()));

            if (timeStr != null && timeStr.trim().length() == 5) {
                timeStr = timeStr.trim() + ":00";
            }
            interview.setInterviewTime(Time.valueOf(timeStr.trim()));
            interview.setInterviewType(type == null || type.trim().isEmpty() ? "ONLINE" : type.trim());
            interview.setMeetingLink(link);
            interview.setInterviewerName(interviewer);
            interview.setNotes(notes);

            int interviewId = interviewDAO.scheduleInterview(interview);

            if (interviewId > 0) {
                applicationDAO.updateStatus(appId, "INTERVIEW");

                Student student = studentDAO.findById(app.getStudentId());
                if (student != null) {
                    Notification notif = new Notification(
                        student.getUserId(),
                        "Interview Scheduled",
                        company.getCompanyName() + " scheduled an interview for " + app.getJobTitle() + " on " + dateStr + " at " + timeStr,
                        "SUCCESS"
                    );
                    notificationDAO.createNotification(notif);
                }

                resp.sendRedirect(req.getContextPath() + "/company/interviews?success=Interview+scheduled+successfully.");
            } else {
                resp.sendRedirect(req.getContextPath() + "/company/applications?error=Failed+to+schedule+interview.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/company/applications?error=Interview+scheduling+failed.");
        }
    }
}
