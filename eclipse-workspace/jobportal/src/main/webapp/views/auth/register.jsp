<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — JobPortal</title>
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/register.css">
    
    <!-- JavaScript -->
    <script src="<%= request.getContextPath() %>/assets/js/register.js" defer></script>
</head>
<body>
    <!-- Floating Background Elements -->
    <div class="floating-element"></div>
    <div class="floating-element"></div>
    <div class="floating-element"></div>

    <!-- Hero Background (More Visible) -->
    <div class="hero-image" style="background-image: url('https://images.unsplash.com/photo-1521791136064-7986c2920216?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');"></div>
    <div class="hero-overlay"></div>

    <!-- Registration Container -->
    <div class="register-container">
        <!-- Back to Home -->
        <a href="<%= request.getContextPath() %>/" class="back-home">
            <i class="fas fa-arrow-left"></i> Back to Home
        </a>
        
        <!-- To Login -->
        <a href="<%= request.getContextPath() %>/views/auth/login.jsp" class="to-login">
            Already have an account? <span>Sign In</span> <i class="fas fa-sign-in-alt"></i>
        </a>

        <!-- Registration Card -->
        <div class="register-card" data-aos="fade-up">
            <!-- Logo and Header -->
            <div class="register-header">
                <div class="logo">
                    <i class="fas fa-briefcase"></i>
                    <h1>JobPortal</h1>
                </div>
                <h2>Create Your Account</h2>
                <p class="subtitle">Join thousands of professionals and companies</p>
            </div>

            <!-- Messages -->
            <% if (request.getParameter("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>Something went wrong. Please try again.</span>
                </div>
            <% } %>

            <% if (request.getParameter("success") != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <span>Account created successfully! You can now login.</span>
                </div>
            <% } %>

            <!-- Registration Form -->
            <form action="<%= request.getContextPath() %>/register" method="post" class="register-form" id="registerForm">
                <!-- Name Field -->
                <div class="form-group">
                    <label for="name">
                        <i class="fas fa-user"></i> Full Name
                    </label>
                    <input type="text" id="name" name="name" required placeholder="Enter your full name">
                    <div class="input-underline"></div>
                    <div class="hint">Enter your first and last name</div>
                </div>

                <!-- Email Field -->
                <div class="form-group">
                    <label for="email">
                        <i class="fas fa-envelope"></i> Email Address
                    </label>
                    <input type="email" id="email" name="email" required placeholder="Enter your email">
                    <div class="input-underline"></div>
                    <div class="hint">We'll never share your email with anyone</div>
                </div>

                <!-- Password Field -->
                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i> Password
                    </label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password" required 
                               placeholder="Create a strong password">
                        <button type="button" class="toggle-password" id="togglePassword">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div class="input-underline"></div>
                    <div class="password-strength" id="passwordStrength">
                        <div class="strength-bar"></div>
                        <div class="strength-text">Password strength: <span>None</span></div>
                    </div>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fas fa-lock"></i> Confirm Password
                    </label>
                    <div class="password-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword" required 
                               placeholder="Confirm your password">
                        <button type="button" class="toggle-password" id="toggleConfirmPassword">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div class="input-underline"></div>
                </div>

                <!-- Role Selection -->
                <div class="form-group">
                    <label for="role">
                        <i class="fas fa-user-tag"></i> I am a
                    </label>
                    <div class="role-selector">
                        <div class="role-option" data-value="seeker">
                            <div class="role-icon">
                                <i class="fas fa-user-tie"></i>
                            </div>
                            <div class="role-info">
                                <h4>Job Seeker</h4>
                                <p>Looking for job opportunities</p>
                            </div>
                            <div class="role-check">
                                <i class="fas fa-check"></i>
                            </div>
                        </div>
                        <div class="role-option" data-value="employer">
                            <div class="role-icon">
                                <i class="fas fa-building"></i>
                            </div>
                            <div class="role-info">
                                <h4>Employer</h4>
                                <p>Looking to hire talent</p>
                            </div>
                            <div class="role-check">
                                <i class="fas fa-check"></i>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" id="role" name="role" value="seeker" required>
                </div>

                <!-- Terms and Conditions -->
                <div class="form-group terms-group">
                    <div class="checkbox-wrapper">
                        <input type="checkbox" id="terms" name="terms" required>
                        <label for="terms" class="terms-label">
                            I agree to the <a href="#" class="terms-link">Terms of Service</a> and <a href="#" class="terms-link">Privacy Policy</a>
                        </label>
                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary register-btn" id="registerButton">
                    <span class="btn-text">Create Account</span>
                    <i class="fas fa-user-plus"></i>
                </button>

                <!-- Divider -->
                <div class="divider">
                    <span>or sign up with</span>
                </div>

                <!-- Social Registration -->
                <div class="social-registration">
                    <button type="button" class="social-btn google-btn" id="googleRegister">
                        <i class="fab fa-google"></i> Google
                    </button>
                    <button type="button" class="social-btn linkedin-btn" id="linkedinRegister">
                        <i class="fab fa-linkedin"></i> LinkedIn
                    </button>
                </div>
            </form>

            <!-- Login Link -->
            <div class="login-link">
                <p>Already have an account? <a href="<%= request.getContextPath() %>/views/auth/login.jsp">Sign in here</a></p>
            </div>

            <!-- Benefits Section -->
            <div class="benefits-section">
                <h3>Why Join JobPortal?</h3>
                <div class="benefits-grid">
                    <div class="benefit-item">
                        <i class="fas fa-bolt"></i>
                        <h4>Quick Setup</h4>
                        <p>Get started in under 2 minutes</p>
                    </div>
                    <div class="benefit-item">
                        <i class="fas fa-shield-alt"></i>
                        <h4>Secure & Private</h4>
                        <p>Your data is protected</p>
                    </div>
                    <div class="benefit-item">
                        <i class="fas fa-users"></i>
                        <h4>Large Community</h4>
                        <p>Join 50,000+ professionals</p>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="register-footer">
                <p>&copy; 2025 JobPortal. All rights reserved.</p>
                <div class="footer-links">
                    <a href="#">Privacy Policy</a>
                    <span>•</span>
                    <a href="#">Terms of Service</a>
                    <span>•</span>
                    <a href="#">Help Center</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>