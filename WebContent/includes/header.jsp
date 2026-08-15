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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- Custom Glassmorphism Style -->
    <link href="${pageContext.request.contextPath}/css/style.css?v=2" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light navbar-hirehub sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
            <div class="company-avatar" style="width: 38px; height: 38px; font-size: 1.1rem;">
                <i class="bi bi-briefcase-fill text-primary"></i>
            </div>
            <span class="navbar-brand-logo">HireHub</span>
        </a>

        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/"><i class="bi bi-house-door me-1"></i>Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/jobs"><i class="bi bi-search me-1"></i>Find Jobs</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/companies"><i class="bi bi-building me-1"></i>Companies</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/about.jsp"><i class="bi bi-info-circle me-1"></i>About</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/contact.jsp"><i class="bi bi-envelope me-1"></i>Contact</a>
                </li>
            </ul>

            <ul class="navbar-nav ms-auto align-items-lg-center gap-2">
                <% if (loggedInUser == null) { %>
                    <li class="nav-item">
                        <a class="btn btn-outline-primary rounded-pill px-4" href="${pageContext.request.contextPath}/login.jsp"><i class="bi bi-box-arrow-in-right me-1"></i>Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-primary rounded-pill px-4" href="${pageContext.request.contextPath}/register.jsp"><i class="bi bi-person-plus me-1"></i>Register</a>
                    </li>
                <% } else { %>
                    <!-- Notification Dropdown -->
                    <li class="nav-item dropdown me-lg-2">
                        <a class="nav-link position-relative dropdown-toggle d-flex align-items-center" href="#" id="notifDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-bell-fill fs-5 text-secondary"></i>
                            <% if (unreadNotifCount > 0) { %>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    <%= unreadNotifCount %>
                                </span>
                            <% } %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-lg p-2" style="width: 330px; max-height: 380px; overflow-y: auto;">
                            <li class="dropdown-header d-flex justify-content-between align-items-center px-2 py-1">
                                <span class="fw-bold text-dark fs-6"><i class="bi bi-bell me-1"></i>Notifications</span>
                                <% if (unreadNotifCount > 0) { %>
                                    <form action="${pageContext.request.contextPath}/notifications-read" method="post" class="d-inline">
                                        <button type="submit" class="btn btn-link btn-sm text-decoration-none p-0 text-primary fw-semibold">Mark all read</button>
                                    </form>
                                <% } %>
                            </li>
                            <li><hr class="dropdown-divider my-2"></li>
                            <% if (notificationsList != null && !notificationsList.isEmpty()) { 
                                for (Notification n : notificationsList) { %>
                                    <li class="p-2 rounded mb-1 bg-light">
                                        <div class="small fw-semibold text-dark"><%= n.getTitle() %></div>
                                        <div class="small text-muted mb-1"><%= n.getMessage() %></div>
                                        <div class="text-muted" style="font-size: 0.725rem;"><i class="bi bi-clock me-1"></i><%= n.getCreatedAt() %></div>
                                    </li>
                            <%  }
                               } else { %>
                                <li class="text-center p-3 text-muted small"><i class="bi bi-bell-slash d-block fs-3 mb-1"></i>No notifications yet</li>
                            <% } %>
                        </ul>
                    </li>

                    <!-- Role Dashboard Quick Links -->
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
                        <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <div class="company-avatar" style="width: 32px; height: 32px; font-size: 0.9rem;">
                                <i class="bi bi-person-fill"></i>
                            </div>
                            <span class="d-none d-lg-inline fw-semibold text-dark" style="max-width: 140px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><%= loggedInUser.getEmail() %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-lg">
                            <% if ("STUDENT".equalsIgnoreCase(loggedInUser.getRole())) { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/profile"><i class="bi bi-person me-2 text-primary"></i>My Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/student/settings"><i class="bi bi-gear me-2 text-secondary"></i>Settings</a></li>
                            <% } else if ("COMPANY".equalsIgnoreCase(loggedInUser.getRole())) { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/company/profile"><i class="bi bi-building me-2 text-primary"></i>Company Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/company/settings"><i class="bi bi-gear me-2 text-secondary"></i>Settings</a></li>
                            <% } else if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reports"><i class="bi bi-graph-up me-2 text-primary"></i>Reports</a></li>
                            <% } %>
                            <li><hr class="dropdown-divider my-1"></li>
                            <li><a class="dropdown-item text-danger fw-semibold" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-3">
    <% if (request.getParameter("success") != null) { %>
        <div class="alert alert-success alert-dismissible fade show glass-card border-success border-opacity-25 shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2 text-success"></i><%= request.getParameter("success") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show glass-card border-danger border-opacity-25 shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2 text-danger"></i><%= request.getParameter("error") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show glass-card border-danger border-opacity-25 shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2 text-danger"></i><%= request.getAttribute("errorMessage") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
</div>
