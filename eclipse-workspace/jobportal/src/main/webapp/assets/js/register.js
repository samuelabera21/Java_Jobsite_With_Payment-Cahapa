// JobPortal Registration - Enhanced with Landing Page Animations
class RegistrationPage {
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
        this.setupRoleSelection();
        this.setupPasswordStrength();
        this.setupAnimations();
        this.setupSocialRegistration();
        this.setupButtonEffects();
        this.setupTermsValidation();
    }

    setupTheme() {
        // Check for saved theme preference
        if (localStorage.getItem('theme') === 'dark') {
            document.body.classList.add('dark');
        }
    }

    setupFormValidation() {
        const registerForm = document.getElementById('registerForm');
        const nameInput = document.getElementById('name');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const registerButton = document.getElementById('registerButton');

        if (registerForm) {
            registerForm.addEventListener('submit', (e) => {
                e.preventDefault();
                
                // Reset previous errors
                this.clearErrors();
                
                // Get form values
                const name = nameInput.value.trim();
                const email = emailInput.value.trim();
                const password = passwordInput.value.trim();
                const confirmPassword = confirmPasswordInput.value.trim();
                const role = document.getElementById('role').value;
                const terms = document.getElementById('terms').checked;
                
                // Validation flags
                let isValid = true;
                
                // Name validation
                if (!name) {
                    this.showError(nameInput, 'Full name is required');
                    isValid = false;
                } else if (name.length < 2) {
                    this.showError(nameInput, 'Name must be at least 2 characters');
                    isValid = false;
                }
                
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
                } else if (password.length < 8) {
                    this.showError(passwordInput, 'Password must be at least 8 characters');
                    isValid = false;
                } else if (!this.isStrongPassword(password)) {
                    this.showError(passwordInput, 'Password must contain letters, numbers, and special characters');
                    isValid = false;
                }
                
                // Confirm password validation
                if (!confirmPassword) {
                    this.showError(confirmPasswordInput, 'Please confirm your password');
                    isValid = false;
                } else if (password !== confirmPassword) {
                    this.showError(confirmPasswordInput, 'Passwords do not match');
                    isValid = false;
                }
                
                // Role validation
                if (!role) {
                    this.showToast('Please select your role', 'error');
                    isValid = false;
                }
                
                // Terms validation
                if (!terms) {
                    this.showToast('You must agree to the terms and conditions', 'error');
                    isValid = false;
                }
                
                // If valid, proceed with form submission
                if (isValid) {
                    this.showLoading(registerButton, 'Creating account...');
                    
                    // Show success animation
                    setTimeout(() => {
                        this.showSuccessAnimation();
                        
                        // Submit the form after animation
                        setTimeout(() => {
                            registerForm.submit();
                        }, 2000);
                    }, 1500);
                }
            });
            
            // Real-time validation
            nameInput.addEventListener('blur', () => {
                if (nameInput.value && nameInput.value.length < 2) {
                    this.showError(nameInput, 'Name must be at least 2 characters');
                } else {
                    this.clearError(nameInput);
                }
            });
            
            emailInput.addEventListener('blur', () => {
                if (emailInput.value && !this.isValidEmail(emailInput.value)) {
                    this.showError(emailInput, 'Please enter a valid email');
                } else {
                    this.clearError(emailInput);
                }
            });
            
            confirmPasswordInput.addEventListener('blur', () => {
                if (confirmPasswordInput.value && passwordInput.value !== confirmPasswordInput.value) {
                    this.showError(confirmPasswordInput, 'Passwords do not match');
                } else {
                    this.clearError(confirmPasswordInput);
                }
            });
            
            // Clear errors on focus
            nameInput.addEventListener('focus', () => this.clearError(nameInput));
            emailInput.addEventListener('focus', () => this.clearError(emailInput));
            passwordInput.addEventListener('focus', () => this.clearError(passwordInput));
            confirmPasswordInput.addEventListener('focus', () => this.clearError(confirmPasswordInput));
        }
    }

    setupPasswordToggle() {
        const toggleButtons = [
            { button: 'togglePassword', input: 'password' },
            { button: 'toggleConfirmPassword', input: 'confirmPassword' }
        ];
        
        toggleButtons.forEach(({ button, input }) => {
            const toggleButton = document.getElementById(button);
            const passwordInput = document.getElementById(input);
            
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
        });
    }

    setupRoleSelection() {
        const roleOptions = document.querySelectorAll('.role-option');
        const roleInput = document.getElementById('role');
        
        roleOptions.forEach(option => {
            option.addEventListener('click', () => {
                const value = option.getAttribute('data-value');
                
                // Remove selected class from all options
                roleOptions.forEach(opt => opt.classList.remove('selected'));
                
                // Add selected class to clicked option
                option.classList.add('selected');
                
                // Update hidden input value
                roleInput.value = value;
                
                // Add animation
                option.classList.add('pulse');
                setTimeout(() => option.classList.remove('pulse'), 600);
                
                // Show confirmation message
                const message = value === 'employer' 
                    ? 'Employer account selected - You can post jobs and hire talent'
                    : 'Job seeker account selected - Find your dream job!';
                
                this.showToast(message, 'success');
            });
        });
        
        // Set default selection
        roleOptions[0].classList.add('selected');
    }

    setupPasswordStrength() {
        const passwordInput = document.getElementById('password');
        const strengthBar = document.querySelector('.strength-bar');
        const strengthText = document.querySelector('.strength-text span');
        
        if (passwordInput && strengthBar && strengthText) {
            passwordInput.addEventListener('input', () => {
                const password = passwordInput.value;
                const strength = this.calculatePasswordStrength(password);
                
                // Update strength bar
                strengthBar.style.setProperty('--strength-width', `${strength.percentage}%`);
                strengthBar.style.backgroundColor = strength.color;
                
                // Update strength text
                strengthText.textContent = strength.text;
                strengthText.style.color = strength.color;
                
                // Update bar color
                strengthBar.querySelector('::before').style.backgroundColor = strength.color;
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
        
        // Animate benefits section
        const benefits = document.querySelectorAll('.benefit-item');
        benefits.forEach((benefit, index) => {
            benefit.style.opacity = '0';
            benefit.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                benefit.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                benefit.style.opacity = '1';
                benefit.style.transform = 'translateY(0)';
            }, 300 + (index * 100));
        });
        
        // Add hover effects to role options
        const roleOptions = document.querySelectorAll('.role-option');
        roleOptions.forEach(option => {
            option.addEventListener('mouseenter', () => {
                option.style.transform = 'translateY(-4px) scale(1.02)';
            });
            
            option.addEventListener('mouseleave', () => {
                if (!option.classList.contains('selected')) {
                    option.style.transform = 'translateY(0) scale(1)';
                }
            });
        });
    }

    setupSocialRegistration() {
        const googleBtn = document.getElementById('googleRegister');
        const linkedinBtn = document.getElementById('linkedinRegister');
        
        if (googleBtn) {
            googleBtn.addEventListener('click', () => {
                this.showLoading(googleBtn, 'Connecting to Google...');
                
                // Simulate social registration
                setTimeout(() => {
                    this.showToast('Google registration would be implemented here', 'info');
                    this.hideLoading(googleBtn, '<i class="fab fa-google"></i> Google');
                }, 1500);
            });
        }
        
        if (linkedinBtn) {
            linkedinBtn.addEventListener('click', () => {
                this.showLoading(linkedinBtn, 'Connecting to LinkedIn...');
                
                // Simulate social registration
                setTimeout(() => {
                    this.showToast('LinkedIn registration would be implemented here', 'info');
                    this.hideLoading(linkedinBtn, '<i class="fab fa-linkedin"></i> LinkedIn');
                }, 1500);
            });
        }
    }

    setupButtonEffects() {
        const buttons = document.querySelectorAll('.btn, .social-btn, .role-option, .benefit-item');
        
        buttons.forEach(button => {
            button.addEventListener('mouseenter', (e) => {
                const rect = button.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                button.style.setProperty('--mouse-x', `${x}px`);
                button.style.setProperty('--mouse-y', `${y}px`);
            });
        });
        
        // Setup ripple effect
        this.setupRippleEffect();
    }

    setupTermsValidation() {
        const termsCheckbox = document.getElementById('terms');
        const termsLinks = document.querySelectorAll('.terms-link');
        
        if (termsCheckbox) {
            termsCheckbox.addEventListener('change', () => {
                if (termsCheckbox.checked) {
                    this.showToast('Terms and conditions accepted', 'success');
                }
            });
        }
        
        // Terms links click handler
        termsLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                this.showToast('Terms and conditions modal would open here', 'info');
            });
        });
    }

    setupRippleEffect() {
        const buttons = document.querySelectorAll('.btn-primary, .social-btn, .role-option');
        
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

    isStrongPassword(password) {
        // At least 8 characters, contains letters, numbers, and special characters
        const re = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
        return re.test(password);
    }

    calculatePasswordStrength(password) {
        let strength = 0;
        let text = 'None';
        let color = '#ef4444'; // Red for weak
        let percentage = 0;
        
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;
        
        switch(strength) {
            case 0:
                text = 'None';
                color = '#9ca3af';
                percentage = 0;
                break;
            case 1:
                text = 'Weak';
                color = '#ef4444';
                percentage = 25;
                break;
            case 2:
                text = 'Fair';
                color = '#f59e0b';
                percentage = 50;
                break;
            case 3:
                text = 'Good';
                color = '#3b82f6';
                percentage = 75;
                break;
            case 4:
                text = 'Strong';
                color = '#10b981';
                percentage = 100;
                break;
        }
        
        return { text, color, percentage };
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

    showSuccessAnimation() {
        // Create success animation overlay
        const overlay = document.createElement('div');
        overlay.className = 'success-overlay';
        overlay.innerHTML = `
            <div class="success-content">
                <div class="success-icon">
                    <i class="fas fa-check"></i>
                </div>
                <h3>Account Created Successfully!</h3>
                <p>Redirecting to login page...</p>
            </div>
        `;
        
        // Styles for success overlay
        overlay.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(16, 185, 129, 0.95);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            animation: fadeIn 0.5s ease;
        `;
        
        document.body.appendChild(overlay);
        
        // Remove overlay after 2 seconds
        setTimeout(() => {
            overlay.style.animation = 'fadeOut 0.5s ease';
            setTimeout(() => overlay.remove(), 500);
        }, 2000);
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

// Initialize registration page
document.addEventListener('DOMContentLoaded', () => {
    new RegistrationPage();
    
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
        background: linear-gradient(90deg, var(--success), var(--accent));
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