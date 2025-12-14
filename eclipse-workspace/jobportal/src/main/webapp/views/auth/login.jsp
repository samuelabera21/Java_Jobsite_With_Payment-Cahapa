<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — JobPortal</title>
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/login.css">
    
    <!-- JavaScript -->
    <script src="<%= request.getContextPath() %>/assets/js/login.js" defer></script>
</head>
<body>
    <!-- Floating Background Elements -->
    <div class="floating-element"></div>
    <div class="floating-element"></div>
    <div class="floating-element"></div>

    <!-- Hero Background -->
    <div class="hero-image" style="background-image: url('https://images.unsplash.com/photo-1497366754035-f200968a6e72?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');"></div>
    <div class="hero-overlay"></div>

    <!-- Login Container -->
    <div class="login-container">
        <!-- Back to Home -->
        <a href="<%= request.getContextPath() %>/" class="back-home">
            <i class="fas fa-arrow-left"></i> Back to Home
        </a>

        <!-- Login Card -->
        <div class="login-card" data-aos="fade-up">
            <!-- Logo and Header -->
            <div class="login-header">
                <div class="logo">
                    <i class="fas fa-briefcase"></i>
                    <h1>JobPortal</h1>
                </div>
                <h2>Welcome Back</h2>
                <p class="subtitle">Sign in to continue your journey</p>
            </div>

            <!-- Error Message -->
            <% if (request.getParameter("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>Invalid email or password!</span>
                </div>
            <% } %>

            <!-- Login Form -->
            <form action="<%= request.getContextPath() %>/login" method="post" class="login-form" id="loginForm">
                <!-- Email Field -->
                <div class="form-group">
                    <label for="email">
                        <i class="fas fa-envelope"></i> Email Address
                    </label>
                    <input type="email" id="email" name="email" required placeholder="Enter your email">
                    <div class="input-underline"></div>
                </div>

                <!-- Password Field -->
                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i> Password
                    </label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password" required placeholder="Enter your password">
                        <button type="button" class="toggle-password" id="togglePassword">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div class="input-underline"></div>
                </div>

                <!-- Remember Me & Forgot Password -->
                <div class="form-options">
                    <div class="remember-me">
                        <input type="checkbox" id="remember" name="remember">
                        <label for="remember">Remember me</label>
                    </div>
                    <a href="#" class="forgot-password" id="forgotPassword">Forgot password?</a>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary login-btn" id="loginButton">
                    <span class="btn-text">Sign In</span>
                    <i class="fas fa-arrow-right"></i>
                </button>

                <!-- Divider -->
                <div class="divider">
                    <span>or continue with</span>
                </div>

                <!-- Social Login -->
                <div class="social-login">
                    <button type="button" class="social-btn google-btn" id="googleLogin">
                        <i class="fab fa-google"></i> Google
                    </button>
                    <button type="button" class="social-btn linkedin-btn" id="linkedinLogin">
                        <i class="fab fa-linkedin"></i> LinkedIn
                    </button>
                </div>
            </form>

            <!-- Register Link -->
            <div class="register-link">
                <p>Don't have an account? <a href="<%= request.getContextPath() %>/views/auth/register.jsp">Create one now</a></p>
            </div>

            <!-- User Type Info -->
            <div class="user-type-info">
                <p>Are you a?</p>
                <div class="user-badges">
                    <span class="badge employer-badge" data-type="employer">
                        <i class="fas fa-building"></i> Employer
                    </span>
                    <span class="badge seeker-badge" data-type="seeker">
                        <i class="fas fa-user-tie"></i> Job Seeker
                    </span>
                </div>
            </div>

            <!-- Footer -->
            <div class="login-footer">
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