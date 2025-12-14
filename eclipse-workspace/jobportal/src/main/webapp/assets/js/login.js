// JobPortal Login - Enhanced with Landing Page Animations
class LoginPage {
    constructor() {
        this.init();
    }

    init() {
        // Initialize when DOM is loaded
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setup());
        } else {
            this.setup();
        }
    }

    setup() {
        // Setup all animations and event listeners
        this.setupTheme();
        this.setupFormValidation();
        this.setupPasswordToggle();
        this.setupAnimations();
        this.setupSocialLogin();
        this.setupUserTypeSelection();
        this.setupForgotPassword();
        this.setupButtonEffects();
    }

    setupTheme() {
        // Check for saved theme preference
        if (localStorage.getItem('theme') === 'dark') {
            document.body.classList.add('dark');
        }
    }

    setupFormValidation() {
        const loginForm = document.getElementById('loginForm');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        const loginButton = document.getElementById('loginButton');

        if (loginForm) {
            loginForm.addEventListener('submit', (e) => {
                e.preventDefault();
                
                // Reset previous errors
                this.clearErrors();
                
                // Get form values
                const email = emailInput.value.trim();
                const password = passwordInput.value.trim();
                
                // Validation flags
                let isValid = true;
                
                // Email validation
                if (!email) {
                    this.showError(emailInput, 'Email is required');
                    isValid = false;
                } else if (!this.isValidEmail(email)) {
                    this.showError(emailInput, 'Please enter a valid email address');
                    isValid = false;
                }
                
                // Password validation
                if (!password) {
                    this.showError(passwordInput, 'Password is required');
                    isValid = false;
                } else if (password.length < 6) {
                    this.showError(passwordInput, 'Password must be at least 6 characters');
                    isValid = false;
                }
                
                // If valid, proceed with form submission
                if (isValid) {
                    this.showLoading(loginButton);
                    
                    // Simulate API call delay
                    setTimeout(() => {
                        loginForm.submit();
                    }, 1500);
                }
            });
            
            // Real-time validation
            emailInput.addEventListener('blur', () => {
                if (emailInput.value && !this.isValidEmail(emailInput.value)) {
                    this.showError(emailInput, 'Please enter a valid email');
                } else {
                    this.clearError(emailInput);
                }
            });
            
            passwordInput.addEventListener('blur', () => {
                if (passwordInput.value && passwordInput.value.length < 6) {
                    this.showError(passwordInput, 'Password must be at least 6 characters');
                } else {
                    this.clearError(passwordInput);
                }
            });
            
            // Clear errors on focus
            emailInput.addEventListener('focus', () => this.clearError(emailInput));
            passwordInput.addEventListener('focus', () => this.clearError(passwordInput));
        }
    }

    setupPasswordToggle() {
        const toggleButton = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');
        
        if (toggleButton && passwordInput) {
            toggleButton.addEventListener('click', () => {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                
                // Toggle icon
                const icon = toggleButton.querySelector('i');
                icon.className = type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
                
                // Add animation effect
                toggleButton.classList.add('pulse');
                setTimeout(() => toggleButton.classList.remove('pulse'), 300);
            });
        }
    }

    setupAnimations() {
        // Animate form elements on load
        const formGroups = document.querySelectorAll('.form-group');
        formGroups.forEach((group, index) => {
            group.style.opacity = '0';
            group.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                group.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                group.style.opacity = '1';
                group.style.transform = 'translateY(0)';
            }, 100 * index);
        });
        
        // Add hover effects to badges
        const badges = document.querySelectorAll('.badge');
        badges.forEach(badge => {
            badge.addEventListener('mouseenter', () => {
                badge.style.transform = 'translateY(-4px) scale(1.05)';
            });
            
            badge.addEventListener('mouseleave', () => {
                badge.style.transform = 'translateY(0) scale(1)';
            });
        });
        
        // Add ripple effect to buttons
        this.setupRippleEffect();
    }

    setupSocialLogin() {
        const googleBtn = document.getElementById('googleLogin');
        const linkedinBtn = document.getElementById('linkedinLogin');
        
        if (googleBtn) {
            googleBtn.addEventListener('click', () => {
                this.showLoading(googleBtn, 'Connecting to Google...');
                
                // Simulate social login
                setTimeout(() => {
                    alert('Google login would be implemented here');
                    this.hideLoading(googleBtn, '<i class="fab fa-google"></i> Google');
                }, 1500);
            });
        }
        
        if (linkedinBtn) {
            linkedinBtn.addEventListener('click', () => {
                this.showLoading(linkedinBtn, 'Connecting to LinkedIn...');
                
                // Simulate social login
                setTimeout(() => {
                    alert('LinkedIn login would be implemented here');
                    this.hideLoading(linkedinBtn, '<i class="fab fa-linkedin"></i> LinkedIn');
                }, 1500);
            });
        }
    }

    setupUserTypeSelection() {
        const badges = document.querySelectorAll('.badge');
        
        badges.forEach(badge => {
            badge.addEventListener('click', () => {
                const type = badge.getAttribute('data-type');
                
                // Remove active state from all badges
                badges.forEach(b => b.classList.remove('active'));
                
                // Add active state to clicked badge
                badge.classList.add('active');
                
                // Add pulse animation
                badge.classList.add('pulse');
                setTimeout(() => badge.classList.remove('pulse'), 600);
                
                // Store user type preference
                localStorage.setItem('userType', type);
                
                // Show confirmation message
                const message = type === 'employer' 
                    ? 'Employer mode selected - You\'ll be redirected to employer registration'
                    : 'Job seeker mode selected - Find your dream job!';
                
                this.showToast(message, type === 'employer' ? 'info' : 'success');
            });
        });
    }

    setupForgotPassword() {
        const forgotLink = document.getElementById('forgotPassword');
        
        if (forgotLink) {
            forgotLink.addEventListener('click', (e) => {
                e.preventDefault();
                
                const email = prompt('Please enter your email address to reset your password:');
                if (email && this.isValidEmail(email)) {
                    this.showLoading(forgotLink, 'Sending reset link...');
                    
                    // Simulate sending reset link
                    setTimeout(() => {
                        this.hideLoading(forgotLink, 'Forgot password?');
                        this.showToast(`Password reset link sent to ${email}`, 'success');
                    }, 1500);
                } else if (email) {
                    this.showToast('Please enter a valid email address', 'error');
                }
            });
        }
    }

    setupButtonEffects() {
        const buttons = document.querySelectorAll('.btn, .social-btn, .badge');
        
        buttons.forEach(button => {
            button.addEventListener('mouseenter', (e) => {
                const rect = button.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                button.style.setProperty('--mouse-x', `${x}px`);
                button.style.setProperty('--mouse-y', `${y}px`);
            });
        });
    }

    setupRippleEffect() {
        const buttons = document.querySelectorAll('.btn-primary, .social-btn, .badge');
        
        buttons.forEach(button => {
            button.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.width = ripple.style.height = size + 'px';
                ripple.style.left = x + 'px';
                ripple.style.top = y + 'px';
                ripple.classList.add('ripple');
                
                const existingRipple = this.querySelector('.ripple');
                if (existingRipple) {
                    existingRipple.remove();
                }
                
                this.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });
        
        // Add ripple styles
        const style = document.createElement('style');
        style.textContent = `
            .ripple {
                position: absolute;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.7);
                transform: scale(0);
                animation: ripple 0.6s linear;
            }
            
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    }

    // Utility Methods
    isValidEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    showError(input, message) {
        const formGroup = input.closest('.form-group');
        if (!formGroup) return;
        
        // Remove existing error
        this.clearError(input);
        
        // Add error class
        formGroup.classList.add('error');
        
        // Create error message
        const errorEl = document.createElement('div');
        errorEl.className = 'error-text';
        errorEl.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
        errorEl.style.color = 'var(--danger)';
        errorEl.style.fontSize = '0.85rem';
        errorEl.style.marginTop = '8px';
        errorEl.style.display = 'flex';
        errorEl.style.alignItems = 'center';
        errorEl.style.gap = '8px';
        
        formGroup.appendChild(errorEl);
        
        // Add shake animation
        formGroup.classList.add('shake');
        setTimeout(() => formGroup.classList.remove('shake'), 500);
    }

    clearError(input) {
        const formGroup = input.closest('.form-group');
        if (!formGroup) return;
        
        formGroup.classList.remove('error');
        const errorText = formGroup.querySelector('.error-text');
        if (errorText) {
            errorText.remove();
        }
    }

    clearErrors() {
        document.querySelectorAll('.form-group').forEach(group => {
            group.classList.remove('error');
            const errorText = group.querySelector('.error-text');
            if (errorText) {
                errorText.remove();
            }
        });
    }

    showLoading(button, text = 'Loading...') {
        const originalContent = button.innerHTML;
        button.setAttribute('data-original', originalContent);
        button.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${text}`;
        button.disabled = true;
        button.classList.add('loading');
    }

    hideLoading(button, originalContent = null) {
        const content = originalContent || button.getAttribute('data-original');
        if (content) {
            button.innerHTML = content;
        }
        button.disabled = false;
        button.classList.remove('loading');
    }

    showToast(message, type = 'info') {
        // Create toast container if it doesn't exist
        let container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container';
            container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1000;
                display: flex;
                flex-direction: column;
                gap: 10px;
            `;
            document.body.appendChild(container);
        }
        
        // Create toast
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
            <span>${message}</span>
            <button class="toast-close"><i class="fas fa-times"></i></button>
        `;
        
        // Toast styles
        toast.style.cssText = `
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 20px;
            background: ${type === 'success' ? 'var(--success)' : type === 'error' ? 'var(--danger)' : 'var(--primary)'};
            color: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            animation: slideIn 0.3s ease;
            min-width: 300px;
            max-width: 400px;
        `;
        
        // Add styles for animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            
            .toast-close {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                margin-left: auto;
                opacity: 0.7;
                transition: opacity 0.3s;
            }
            
            .toast-close:hover {
                opacity: 1;
            }
        `;
        if (!document.querySelector('#toast-styles')) {
            style.id = 'toast-styles';
            document.head.appendChild(style);
        }
        
        // Close button functionality
        const closeBtn = toast.querySelector('.toast-close');
        closeBtn.addEventListener('click', () => {
            toast.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => toast.remove(), 300);
        });
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (toast.parentNode) {
                toast.style.animation = 'slideOut 0.3s ease forwards';
                setTimeout(() => toast.remove(), 300);
            }
        }, 5000);
        
        container.appendChild(toast);
    }
}

// Initialize login page
document.addEventListener('DOMContentLoaded', () => {
    new LoginPage();
    
    // Add typing effect to form labels
    const labels = document.querySelectorAll('.form-group label');
    labels.forEach((label, index) => {
        const originalText = label.textContent;
        label.textContent = '';
        
        setTimeout(() => {
            let charIndex = 0;
            function typeWriter() {
                if (charIndex < originalText.length) {
                    label.textContent += originalText.charAt(charIndex);
                    charIndex++;
                    setTimeout(typeWriter, 30);
                }
            }
            typeWriter();
        }, 500 + (index * 200));
    });
    
    // Add scroll progress indicator
    const progressBar = document.createElement('div');
    progressBar.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        height: 3px;
        background: linear-gradient(90deg, var(--primary), var(--secondary));
        width: 0%;
        z-index: 1001;
        transition: width 0.3s ease;
    `;
    document.body.appendChild(progressBar);
    
    // Update progress bar on scroll
    window.addEventListener('scroll', () => {
        const scrolled = (window.scrollY / (document.documentElement.scrollHeight - window.innerHeight)) * 100;
        progressBar.style.width = scrolled + '%';
    });
});