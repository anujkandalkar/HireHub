<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Company" %>
<%
    Company company = (Company) request.getAttribute("company");
    if (company == null) company = (Company) session.getAttribute("companyProfile");
    request.setAttribute("pageTitle", "Company Profile - HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
                    <h4 class="fw-bold text-dark mb-4"><i class="bi bi-building me-2 text-primary"></i>Company Profile Settings</h4>

                    <form action="${pageContext.request.contextPath}/company/profile-update" method="post">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Company Name</label>
                                <input type="text" name="companyName" class="form-control" value="<%= company != null && company.getCompanyName() != null ? company.getCompanyName() : "" %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Official Phone</label>
                                <input type="text" name="phone" class="form-control" value="<%= company != null && company.getPhone() != null ? company.getPhone() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Website URL</label>
                                <input type="url" name="website" class="form-control" value="<%= company != null && company.getWebsite() != null ? company.getWebsite() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Industry</label>
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
                                <label class="form-label fw-semibold">Location / Headquarters</label>
                                <input type="text" name="location" class="form-control" value="<%= company != null && company.getLocation() != null ? company.getLocation() : "" %>">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Logo Image URL</label>
                                <input type="text" name="logoUrl" class="form-control" placeholder="https://..." value="<%= company != null && company.getLogoUrl() != null ? company.getLogoUrl() : "" %>">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-semibold">Company Description</label>
                                <textarea name="description" class="form-control" rows="4"><%= company != null && company.getDescription() != null ? company.getDescription() : "" %></textarea>
                            </div>
                            <div class="col-12 text-end mt-4">
                                <button type="submit" class="btn btn-primary rounded-pill px-4">Update Profile</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
