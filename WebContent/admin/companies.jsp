<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hirehub.model.Company, java.util.List" %>
<%
    List<Company> companies = (List<Company>) request.getAttribute("companies");
    request.setAttribute("pageTitle", "Company Verification & Management — HireHub");
%>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold text-dark mb-1">Company Verification & Account Approvals</h3>
                <p class="text-muted mb-0">Approve pending recruiter profiles, verify enterprise details, or block non-compliant accounts</p>
            </div>
            <form action="${pageContext.request.contextPath}/admin/companies" method="get" class="d-flex flex-column flex-sm-row gap-2">
                <select name="status" class="form-select rounded-pill px-3" style="height: 48px; min-width: 180px;">
                    <option value="ALL">All Statuses</option>
                    <option value="PENDING" <%= "PENDING".equals(request.getAttribute("status")) ? "selected" : "" %>>Pending Approval</option>
                    <option value="APPROVED" <%= "APPROVED".equals(request.getAttribute("status")) ? "selected" : "" %>>Approved</option>
                    <option value="REJECTED" <%= "REJECTED".equals(request.getAttribute("status")) ? "selected" : "" %>>Rejected</option>
                    <option value="BLOCKED" <%= "BLOCKED".equals(request.getAttribute("status")) ? "selected" : "" %>>Blocked</option>
                </select>
                <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm" style="height: 48px; white-space: nowrap;">Filter</button>
            </form>
        </div>

        <div class="glass-card overflow-hidden">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Company Name</th>
                            <th>Email Address</th>
                            <th>Industry</th>
                            <th>HQ Location</th>
                            <th>Status</th>
                            <th>Reg Date</th>
                            <th class="text-end pe-4">Approval Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (companies != null && !companies.isEmpty()) { 
                            for (Company c : companies) { 
                                String st = c.getApprovalStatus();
                                String badgeColor = "bg-success";
                                if ("PENDING".equalsIgnoreCase(st)) badgeColor = "bg-warning text-dark";
                                else if ("REJECTED".equalsIgnoreCase(st) || "BLOCKED".equalsIgnoreCase(st)) badgeColor = "bg-danger";
                        %>
                            <tr>
                                <td class="ps-4 fw-bold">
                                    <a href="${pageContext.request.contextPath}/admin/company-details?id=<%= c.getId() %>" class="text-decoration-none text-dark"><%= c.getCompanyName() %></a>
                                </td>
                                <td><%= c.getEmail() %></td>
                                <td class="small text-muted"><%= c.getIndustry() %></td>
                                <td><%= c.getLocation() %></td>
                                <td><span class="badge <%= badgeColor %> px-3 py-1.5 rounded-pill"><%= st %></span></td>
                                <td class="small text-muted"><%= c.getCreatedAt() %></td>
                                <td class="text-end pe-4">
                                    <div class="d-inline-flex gap-1">
                                        <% if ("PENDING".equalsIgnoreCase(st) || "REJECTED".equalsIgnoreCase(st)) { %>
                                            <form action="${pageContext.request.contextPath}/admin/company-action" method="post" class="d-inline">
                                                <input type="hidden" name="companyId" value="<%= c.getId() %>">
                                                <input type="hidden" name="action" value="APPROVE">
                                                <button type="submit" class="btn btn-sm btn-success rounded-pill px-3 shadow-sm"><i class="bi bi-check-lg me-1"></i>Approve</button>
                                            </form>
                                        <% } %>

                                        <% if ("PENDING".equalsIgnoreCase(st)) { %>
                                            <form action="${pageContext.request.contextPath}/admin/company-action" method="post" class="d-inline">
                                                <input type="hidden" name="companyId" value="<%= c.getId() %>">
                                                <input type="hidden" name="action" value="REJECT">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">Reject</button>
                                            </form>
                                        <% } %>

                                        <% if ("APPROVED".equalsIgnoreCase(st)) { %>
                                            <form action="${pageContext.request.contextPath}/admin/company-action" method="post" class="d-inline">
                                                <input type="hidden" name="companyId" value="<%= c.getId() %>">
                                                <input type="hidden" name="action" value="BLOCK">
                                                <button type="submit" class="btn btn-sm btn-outline-warning rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Block"><i class="bi bi-slash-circle"></i></button>
                                            </form>
                                        <% } else if ("BLOCKED".equalsIgnoreCase(st)) { %>
                                            <form action="${pageContext.request.contextPath}/admin/company-action" method="post" class="d-inline">
                                                <input type="hidden" name="companyId" value="<%= c.getId() %>">
                                                <input type="hidden" name="action" value="UNBLOCK">
                                                <button type="submit" class="btn btn-sm btn-outline-success rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Unblock"><i class="bi bi-check-circle"></i></button>
                                            </form>
                                        <% } %>

                                        <form action="${pageContext.request.contextPath}/admin/company-action" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this company account?')">
                                            <input type="hidden" name="companyId" value="<%= c.getId() %>">
                                            <input type="hidden" name="action" value="DELETE">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-circle d-flex align-items-center justify-content-center" style="width:34px; height:34px;" title="Delete"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr><td colspan="7" class="text-center py-5 text-muted">No companies found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/includes/footer.jsp" />
