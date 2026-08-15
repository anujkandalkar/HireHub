<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Company" %>
<%
    Company company = (Company) request.getAttribute("company");
    if (company == null) company = (Company) session.getAttribute("companyProfile");
    request.setAttribute("pageTitle", "Company Profile — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="glass-card p-4 p-md-5">
                    <div class="d-flex align-items-center gap-3 mb-4 border-bottom pb-3">
                        <div class="company-avatar" style="width: 54px; height: 54px; font-size: 1.5rem;">
                            <i class="bi bi-building"></i>
                        </div>
                        <div>
                            <h4 class="fw-bold text-dark mb-0"><%= company != null && company.getCompanyName() != null ? company.getCompanyName() : "Company Profile" %> Settings</h4>
                            <span class="small text-muted">Manage your verified corporate presence and recruiter profile</span>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/company/profile-update" method="post">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Company Name</label>
                                <input type="text" name="companyName" class="form-control" value="<%= company != null && company.getCompanyName() != null ? company.getCompanyName() : "" %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Official Contact Phone</label>
                                <input type="text" name="phone" class="form-control" value="<%= company != null && company.getPhone() != null ? company.getPhone() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Website URL</label>
                                <input type="url" name="website" class="form-control" value="<%= company != null && company.getWebsite() != null ? company.getWebsite() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Industry Sector</label>
                                <input type="text" name="industry" class="form-control" value="<%= company != null && company.getIndustry() != null ? company.getIndustry() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Company Size</label>
                                <select name="companySize" class="form-select">
                                    <option value="1-10" <%= company != null && "1-10".equals(company.getCompanySize()) ? "selected" : "" %>>1-10 Employees</option>
                                    <option value="11-50" <%= company != null && "11-50".equals(company.getCompanySize()) ? "selected" : "" %>>11-50 Employees</option>
                                    <option value="51-200" <%= company != null && "51-200".equals(company.getCompanySize()) ? "selected" : "" %>>51-200 Employees</option>
                                    <option value="201-1000" <%= company != null && "201-1000".equals(company.getCompanySize()) ? "selected" : "" %>>201-1000 Employees</option>
                                    <option value="1000+" <%= company != null && "1000+".equals(company.getCompanySize()) ? "selected" : "" %>>1000+ Employees</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Headquarters Location</label>
                                <input type="text" name="location" class="form-control" value="<%= company != null && company.getLocation() != null ? company.getLocation() : "" %>">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Logo Image URL</label>
                                <input type="text" name="logoUrl" class="form-control" placeholder="https://..." value="<%= company != null && company.getLogoUrl() != null ? company.getLogoUrl() : "" %>">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Company Overview</label>
                                <textarea name="description" class="form-control" rows="4"><%= company != null && company.getDescription() != null ? company.getDescription() : "" %></textarea>
                            </div>
                            <div class="col-12 text-end mt-4">
                                <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm">
                                    <i class="bi bi-check-circle me-1"></i>Update Profile
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
