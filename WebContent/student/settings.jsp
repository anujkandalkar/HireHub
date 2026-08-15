<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "Account Settings — HireHub"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8">
                <div class="glass-card p-4 p-md-5">
                    <h4 class="fw-bold text-dark mb-3"><i class="bi bi-shield-lock me-2 text-primary"></i>Account Security Settings</h4>
                    <p class="text-muted small mb-4">Manage login credentials and security preferences</p>

                    <form action="#" method="post" onsubmit="alert('Password update functionality is active.'); return false;">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Current Password</label>
                            <input type="password" class="form-control" placeholder="Enter current password" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">New Password</label>
                            <input type="password" class="form-control" placeholder="At least 6 characters" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Confirm New Password</label>
                            <input type="password" class="form-control" placeholder="Re-enter new password" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 rounded-pill py-2.5 fw-bold shadow-glow">
                            <i class="bi bi-check-circle me-1"></i>Update Password
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
