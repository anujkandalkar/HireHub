<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("pageTitle", "Create Account — HireHub Job Portal"); %>
<jsp:include page="/includes/header.jsp" />

<section class="py-5 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="glass-card p-4 p-md-5">
                    <div class="text-center mb-4">
                        <h3 class="fw-bold text-dark mb-1">Join HireHub Platform</h3>
                        <p class="text-muted small">Choose your account type to get started</p>

                        <!-- Role Selector Segmented Controls -->
                        <div class="btn-group w-100 mt-3 p-1 glass-panel rounded-3" role="group">
                            <input type="radio" class="btn-check" name="roleToggle" id="roleStudent" value="STUDENT" checked onclick="toggleRoleForm('STUDENT')">
                            <label class="btn btn-outline-primary border-0 rounded-3 py-2.5 fw-semibold" for="roleStudent">
                                <i class="bi bi-person-badge me-2"></i>Job Seeker / Student
                            </label>

                            <input type="radio" class="btn-check" name="roleToggle" id="roleCompany" value="COMPANY" onclick="toggleRoleForm('COMPANY')">
                            <label class="btn btn-outline-primary border-0 rounded-3 py-2.5 fw-semibold" for="roleCompany">
                                <i class="bi bi-building me-2"></i>Company / Recruiter
                            </label>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data" id="regForm" onsubmit="return validateRegistrationForm()">
                        <input type="hidden" name="role" id="roleInput" value="STUDENT">

                        <!-- Common Credential Inputs -->
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                                <input type="email" name="email" class="form-control" placeholder="name@domain.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Phone Number <span class="text-danger">*</span></label>
                                <input type="text" name="phone" class="form-control" placeholder="+1 555-0199" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Password <span class="text-danger">*</span></label>
                                <input type="password" name="password" id="pwd" class="form-control" placeholder="At least 6 characters" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Confirm Password <span class="text-danger">*</span></label>
                                <input type="password" name="confirmPassword" id="cpwd" class="form-control" placeholder="Re-enter password" required>
                            </div>
                        </div>

                        <!-- STUDENT / JOB SEEKER FIELDS -->
                        <div id="studentFields">
                            <h5 class="fw-bold border-bottom pb-2 mb-3 text-primary"><i class="bi bi-person-vcard me-2"></i>Personal & Academic Details</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                                    <input type="text" name="fullName" id="fullNameInput" class="form-control" placeholder="e.g. Alex Smith" required>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-semibold">Gender</label>
                                    <select name="gender" class="form-select">
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-semibold">Date of Birth</label>
                                    <input type="date" name="dob" class="form-control">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">City</label>
                                    <input type="text" name="city" class="form-control" placeholder="San Jose">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">State</label>
                                    <input type="text" name="state" class="form-control" placeholder="CA">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Degree / Major</label>
                                    <input type="text" name="educationLevel" class="form-control" placeholder="B.S. Computer Science">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">College / University</label>
                                    <input type="text" name="collegeName" class="form-control" placeholder="Stanford University">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Graduation Year</label>
                                    <input type="number" name="graduationYear" class="form-control" placeholder="2025" min="2000" max="2030">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Skills (Comma separated)</label>
                                    <input type="text" name="skills" class="form-control" placeholder="Java, SQL, HTML, CSS, JavaScript">
                                </div>
                                
                                <!-- RESUME UPLOAD -->
                                <div class="col-md-12">
                                    <label class="form-label fw-semibold">Upload Resume (PDF, DOC, DOCX — Max 5 MB) <span class="text-danger">*</span></label>
                                    <div class="p-3 glass-panel rounded-3 border">
                                        <input type="file" name="resumeFile" id="resumeFile" class="form-control" accept=".pdf,.doc,.docx" required onchange="validateResumeFile(this)">
                                        <div class="form-text text-muted" id="resumeHelp">Accepted formats: PDF, DOC, DOCX (Max 5 MB). PDF recommended.</div>
                                        <div class="text-danger small mt-1" id="resumeError" style="display: none;"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- COMPANY / RECRUITER FIELDS -->
                        <div id="companyFields" style="display: none;">
                            <h5 class="fw-bold border-bottom pb-2 mb-3 text-primary"><i class="bi bi-building me-2"></i>Company & Recruiter Details</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Company Name <span class="text-danger">*</span></label>
                                    <input type="text" name="companyName" id="companyNameInput" class="form-control" placeholder="TechNova Solutions">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Official Website</label>
                                    <input type="url" name="website" class="form-control" placeholder="https://technova.com">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Industry Sector</label>
                                    <input type="text" name="industry" class="form-control" placeholder="Software & IT Services">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Company Size</label>
                                    <select name="companySize" class="form-select">
                                        <option value="1-10">1-10 Employees</option>
                                        <option value="11-50">11-50 Employees</option>
                                        <option value="51-200">51-200 Employees</option>
                                        <option value="201-1000">201-1000 Employees</option>
                                        <option value="1000+">1000+ Employees</option>
                                    </select>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label fw-semibold">Headquarters Location</label>
                                    <input type="text" name="companyLocation" class="form-control" placeholder="San Francisco, CA">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label fw-semibold">Company Overview</label>
                                    <textarea name="description" class="form-control" rows="3" placeholder="Briefly describe your company's mission and hiring focus..."></textarea>
                                </div>
                            </div>
                        </div>

                        <button type="submit" id="submitBtn" class="btn btn-primary w-100 py-3 rounded-3 fw-bold fs-6 mb-3 shadow-glow">
                            <i class="bi bi-check-circle-fill me-2"></i>Complete Registration
                        </button>
                    </form>

                    <div class="text-center text-muted small">
                        Already have an account? <a href="${pageContext.request.contextPath}/login.jsp" class="fw-bold text-primary text-decoration-none">Log In Here</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
function toggleRoleForm(role) {
    document.getElementById('roleInput').value = role;
    var studentFields = document.getElementById('studentFields');
    var companyFields = document.getElementById('companyFields');
    var resumeInput = document.getElementById('resumeFile');
    var fullNameInput = document.getElementById('fullNameInput');
    var companyNameInput = document.getElementById('companyNameInput');

    if (role === 'STUDENT') {
        studentFields.style.display = 'block';
        companyFields.style.display = 'none';
        resumeInput.required = true;
        fullNameInput.required = true;
        companyNameInput.required = false;
    } else {
        studentFields.style.display = 'none';
        companyFields.style.display = 'block';
        resumeInput.required = false;
        fullNameInput.required = false;
        companyNameInput.required = true;
    }
}

function validateResumeFile(input) {
    var errDiv = document.getElementById('resumeError');
    errDiv.style.display = 'none';
    errDiv.innerText = '';

    if (!input.files || input.files.length === 0) return true;

    var file = input.files[0];
    var maxBytes = 5 * 1024 * 1024;
    var allowedExts = ['.pdf', '.doc', '.docx'];

    var fileName = file.name.toLowerCase();
    var isValidExt = allowedExts.some(function(ext) {
        return fileName.endsWith(ext);
    });

    if (!isValidExt) {
        errDiv.innerText = 'Invalid file format. Only PDF, DOC, and DOCX files are allowed.';
        errDiv.style.display = 'block';
        input.value = '';
        return false;
    }

    if (file.size > maxBytes) {
        errDiv.innerText = 'Resume size must not exceed 5 MB.';
        errDiv.style.display = 'block';
        input.value = '';
        return false;
    }

    if (file.size === 0) {
        errDiv.innerText = 'The selected file is empty. Please select a valid resume file.';
        errDiv.style.display = 'block';
        input.value = '';
        return false;
    }

    return true;
}

function validateRegistrationForm() {
    var role = document.getElementById('roleInput').value;
    var p1 = document.getElementById('pwd').value;
    var p2 = document.getElementById('cpwd').value;

    if (p1 !== p2) {
        alert('Passwords do not match!');
        return false;
    }

    if (role === 'STUDENT') {
        var resumeInput = document.getElementById('resumeFile');
        if (!resumeInput.files || resumeInput.files.length === 0) {
            alert('Resume file is required for student registration.');
            return false;
        }
        if (!validateResumeFile(resumeInput)) {
            return false;
        }
    }

    document.getElementById('submitBtn').disabled = true;
    document.getElementById('submitBtn').innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Creating Account...';
    return true;
}
</script>

<jsp:include page="/includes/footer.jsp" />
