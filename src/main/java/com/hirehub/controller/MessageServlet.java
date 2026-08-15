package com.hirehub.controller;

import com.hirehub.dao.ApplicationDAO;
import com.hirehub.dao.MessageDAO;
import com.hirehub.dao.NotificationDAO;
import com.hirehub.dao.StudentDAO;
import com.hirehub.model.Application;
import com.hirehub.model.Message;
import com.hirehub.model.Notification;
import com.hirehub.model.Student;
import com.hirehub.model.User;
import com.hirehub.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {
    "/send-message",
    "/mark-message-read"
})
public class MessageServlet extends HttpServlet {

    private MessageDAO messageDAO;
    private ApplicationDAO applicationDAO;
    private StudentDAO studentDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        messageDAO = new MessageDAO();
        applicationDAO = new ApplicationDAO();
        studentDAO = new StudentDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String path = req.getServletPath();

        if ("/send-message".equalsIgnoreCase(path)) {
            try {
                int appId = Integer.parseInt(req.getParameter("applicationId"));
                String subject = ValidationUtil.sanitize(req.getParameter("subject"));
                String messageText = ValidationUtil.sanitize(req.getParameter("message"));

                Application app = applicationDAO.findById(appId);
                if (app == null) {
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
                    return;
                }

                Student student = studentDAO.findById(app.getStudentId());
                int receiverUserId = student.getUserId();

                Message msg = new Message();
                msg.setSenderId(user.getId());
                msg.setReceiverId(receiverUserId);
                msg.setApplicationId(appId);
                msg.setSubject(subject);
                msg.setMessageText(messageText);

                messageDAO.sendMessage(msg);

                Notification notif = new Notification(
                    receiverUserId,
                    "New Recruiter Response: " + subject,
                    messageText.length() > 100 ? messageText.substring(0, 97) + "..." : messageText,
                    "INFO"
                );
                notificationDAO.createNotification(notif);

                resp.sendRedirect(req.getContextPath() + "/company/applications?success=Response+sent+to+candidate.");
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/company/applications?error=Failed+to+send+message.");
            }
        } else if ("/mark-message-read".equalsIgnoreCase(path)) {
            try {
                int msgId = Integer.parseInt(req.getParameter("messageId"));
                messageDAO.markAsRead(msgId, user.getId());
            } catch (Exception e) {}
            resp.sendRedirect(req.getContextPath() + ("STUDENT".equalsIgnoreCase(user.getRole()) ? "/student/messages" : "/company/messages"));
        }
    }
}
