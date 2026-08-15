<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "Contact Us — HireHub Job Portal"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="glass-card p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="company-avatar mx-auto mb-3" style="width:60px; height:60px; font-size:1.5rem;">
                            <i class="bi bi-envelope-paper text-primary"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-1">Get In Touch</h3>
                        <p class="text-muted small">Have questions or need assistance? Send us a message and our support team will respond promptly.</p>
                    </div>

                    <form onsubmit="alert('Thank you for reaching out! We will contact you shortly.'); return false;">
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Your Name</label>
                                <input type="text" class="form-control" placeholder="John Doe" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email Address</label>
                                <input type="email" class="form-control" placeholder="name@example.com" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Subject</label>
                                <input type="text" class="form-control" placeholder="Inquiry about..." required>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Message</label>
                                <textarea class="form-control" rows="4" placeholder="How can we help you?" required></textarea>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-2.5 rounded-3 fw-bold shadow-glow">
                            <i class="bi bi-send-fill me-2"></i>Send Message
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
