<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.User, com.hirehub.model.Notification, com.hirehub.dao.NotificationDAO, java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    int unreadNotifCount = 0;
    List<Notification> notificationsList = null;
    if (loggedInUser != null) {
        NotificationDAO nDao = new NotificationDAO();
        unreadNotifCount = nDao.getUnreadCount(loggedInUser.getId());
        notificationsList = nDao.getNotificationsForUser(loggedInUser.getId());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "HireHub - Modern Job Portal & Recruitment System" %></title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Custom Style -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark navbar-hirehub sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
            <i class="bi bi-briefcase-fill text-primary fs-3 me-2"></i>
            <span class="navbar-brand-logo">HireHub</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/jobs">Find Jobs</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/companies">Companies</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/about.jsp">About</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
                </li>
            </ul>

            <ul class="navbar-nav ms-auto align-items-lg-center">
                <% if (loggedInUser == null) { %>
                    <li class="nav-item me-2">
                        <a class="btn btn-outline-primary px-4 rounded-pill" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-primary px-4 rounded-pill fw-semibold" href="${pageContext.request.contextPath}/register.jsp">Register</a>
                    </li>
                <% } else { %>
                    <!-- Notification Dropdown -->
                    <li class="nav-item dropdown me-3">
                        <a class="nav-link position-relative dropdown-toggle" href="#" id="notifDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-bell-fill fs-5"></i>
                            <% if (unreadNotifCount > 0) { %>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    <%= unreadNotifCount %>
                                </span>
                            <% } %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-lg p-2" style="width: 320px; max-height: 380px; overflow-y: auto;">
                            <li class="dropdown-header d-flex justify-content-between align-items-center">
                                <span class="fw-bold">Notifications</span>
                                <% if (unreadNotifCount > 0) { %>
                                    <form action="${pageContext.request.contextPath}/notifications-read" method="post" class="d-inline">
                                        <button type="submit" class="btn btn-link btn-sm text-decoration-none p-0">Mark read</button>
                                    </form>
                                <% } %>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <% if (notificationsList != null && !notificationsList.isEmpty()) { 
                                for (Notification n : notificationsList) { %>
                                    <li class="p-2 border-bottom">
                                        <div class="small fw-semibold text-dark"><%= n.getTitle() %></div>
                                        <div class="small text-muted"><%= n.getMessage() %></div>
                                        <div class="text-muted" style="font-size: 0.7rem;"><%= n.getCreatedAt() %></div>
                                    </li>
                            <%  }
                               } else { %>
                                <li class="text-center p-3 text-muted small">No notifications</li>
                            <% } %>
                        </ul>
                    </li>

                    <!-- Role Dashboard Links -->
                    <% if ("STUDENT".equalsIgnoreCase(loggedInUser.getRole())) { %>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/applications">Applications</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/student/tasks">Tasks</a></li>
                    <% } else if ("COMPANY".equalsIgnoreCase(loggedInUser.getRole())) { %>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/company/dashboard">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/company/manage-jobs">Manage Jobs</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/company/applications">Applicants</a></li>
                    <% } else if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/companies">Companies</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/students">Students</a></li>
                    <% } %>

                    <!-- User Profile Dropdown -->
                    <li class="nav-item dropdown ms-lg-2">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle fs-4 me-1"></i>
                            <span class="d-none d-lg-inline"><%= loggedInUser.getEmail() %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow">
                            <% if ("STUDENT".equalsIgnoreCase(loggedInUser.getRole())) { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person me-2"></i>My Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/settings"><i class="bi bi-gear me-2"></i>Settings</a></li>
                            <% } else if ("COMPANY".equalsIgnoreCase(loggedInUser.getRole())) { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/company/profile"><i class="bi bi-building me-2"></i>Company Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/company/settings"><i class="bi bi-gear me-2"></i>Settings</a></li>
                            <% } else if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reports"><i class="bi bi-graph-up me-2"></i>Reports</a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-3">
    <% if (request.getParameter("success") != null) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i><%= request.getParameter("success") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i><%= request.getParameter("error") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i><%= request.getAttribute("errorMessage") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
</div>
