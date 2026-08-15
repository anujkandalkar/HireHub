<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "Post New Job — HireHub"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                <div class="glass-card p-4 p-md-5">
                    <h3 class="fw-bold text-dark mb-1"><i class="bi bi-file-earmark-plus me-2 text-primary"></i>Post a New Job Opening</h3>
                    <p class="text-muted small mb-4">Define job criteria and target skills to leverage HireHub's candidate skill match engine</p>

                    <form action="${pageContext.request.contextPath}/company/post-job" method="post">
                        <div class="row g-3 mb-4">
                            <div class="col-md-8">
                                <label class="form-label fw-semibold">Job Title <span class="text-danger">*</span></label>
                                <input type="text" name="title" class="form-control" placeholder="e.g. Senior Java Full Stack Engineer" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Job Type <span class="text-danger">*</span></label>
                                <select name="jobType" class="form-select" required>
                                    <option value="FULL_TIME">Full Time</option>
                                    <option value="PART_TIME">Part Time</option>
                                    <option value="INTERNSHIP">Internship</option>
                                    <option value="CONTRACT">Contract</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Required Skills (Comma separated) <span class="text-danger">*</span></label>
                                <input type="text" name="requiredSkills" class="form-control" placeholder="Java, Spring Boot, MySQL, React, REST API" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Job Location <span class="text-danger">*</span></label>
                                <input type="text" name="location" class="form-control" placeholder="San Francisco, CA or Remote" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Minimum Salary ($/yr)</label>
                                <input type="number" name="salaryMin" class="form-control" placeholder="80000" min="0">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Maximum Salary ($/yr)</label>
                                <input type="number" name="salaryMax" class="form-control" placeholder="130000" min="0">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Experience Required</label>
                                <input type="text" name="experienceYears" class="form-control" placeholder="1-3 Years">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Number of Vacancies</label>
                                <input type="number" name="vacancies" class="form-control" value="1" min="1">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Application Deadline</label>
                                <input type="date" name="deadline" class="form-control">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Job Overview & Description <span class="text-danger">*</span></label>
                                <textarea name="description" class="form-control" rows="4" placeholder="Comprehensive position description..." required></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Key Responsibilities</label>
                                <textarea name="responsibilities" class="form-control" rows="3" placeholder="Primary role responsibilities..."></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Qualifications & Technical Requirements</label>
                                <textarea name="requirements" class="form-control" rows="3" placeholder="Education, certifications, experience criteria..."></textarea>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/company/manage-jobs" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold shadow-glow"><i class="bi bi-check-lg me-1"></i>Publish Job Listing</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
