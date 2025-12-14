/**
 * Change Password Management
 * Enhanced with password validation, strength meter, and security features
 * @class ChangePassword
 * @version 1.0.0
 */

/* global document, window, localStorage, console */

function ChangePassword() {
    this.form = document.getElementById('changePasswordForm');
    this.newPasswordInput = document.getElementById('newPassword');
    this.confirmPasswordInput = document.getElementById('confirmPassword');
    this.toggleNewPasswordBtn = document.getElementById('toggleNewPassword');
    this.toggleConfirmPasswordBtn = document.getElementById('toggleConfirmPassword');
    this.submitBtn = document.getElementById('submitBtn');
    this.cancelBtn = document.getElementById('cancelBtn');
    this.passwordStrength = document.getElementById('passwordStrength');
    this.passwordMatch = document.getElementById('passwordMatch');
    this.themeToggle = document.getElementById('themeToggle');
    this.confirmationModal = document.getElementById('confirmationModal');
    this.confirmCancelBtn = document.getElementById('confirmCancel');
    this.confirmSubmitBtn = document.getElementById('confirmSubmit');
    
    this.init();
}

ChangePassword.prototype.init = function() {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', this.setup.bind(this));
    } else {
        this.setup();
    }
};

ChangePassword.prototype.setup = function() {
    this.setupThemeToggle();
    this.setupPasswordToggles();
    this.setupPasswordValidation();
    this.setupFormValidation();
    this.setupConfirmationModal();
    this.setupFadeAnimations();
    this.setupKeyboardShortcuts();
    this.updateRequirements();
};

ChangePassword.prototype.setupThemeToggle = function() {
    var self = this;
    
    if (this.themeToggle) {
        this.themeToggle.addEventListener('click', function() {
            self.toggleTheme();
        });
        
        // Load saved theme
        var savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'dark') {
            document.body.classList.add('dark-theme');
            this.querySelector('i').className = 'fas fa-sun';
            this.querySelector('span').textContent = 'Light Mode';
        }
    }
};

ChangePassword.prototype.toggleTheme = function() {
    var icon = this.themeToggle.querySelector('i');
    var text = this.themeToggle.querySelector('span');
    
    if (document.body.classList.contains('dark-theme')) {
        document.body.classList.remove('dark-theme');
        icon.className = 'fas fa-moon';
        text.textContent = 'Dark Mode';
        localStorage.setItem('theme', 'light');
        this.showToast('Switched to Light Mode', 'info');
    } else {
        document.body.classList.add('dark-theme');
        icon.className = 'fas fa-sun';
        text.textContent = 'Light Mode';
        localStorage.setItem('theme', 'dark');
        this.showToast('Switched to Dark Mode', 'info');
    }
};

ChangePassword.prototype.setupPasswordToggles = function() {
    var self = this;
    
    // Toggle new password visibility
    if (this.toggleNewPasswordBtn) {
        this.toggleNewPasswordBtn.addEventListener('click', function() {
            self.togglePasswordVisibility(self.newPasswordInput, this);
        });
    }
    
    // Toggle confirm password visibility
    if (this.toggleConfirmPasswordBtn) {
        this.toggleConfirmPasswordBtn.addEventListener('click', function() {
            self.togglePasswordVisibility(self.confirmPasswordInput, this);
        });
    }
};

ChangePassword.prototype.togglePasswordVisibility = function(passwordInput, toggleBtn) {
    var type = passwordInput.getAttribute('type');
    var icon = toggleBtn.querySelector('i');
    
    if (type === 'password') {
        passwordInput.setAttribute('type', 'text');
        icon.className = 'fas fa-eye-slash';
        toggleBtn.classList.add('active');
        this.showToast('Password shown', 'info');
    } else {
        passwordInput.setAttribute('type', 'password');
        icon.className = 'fas fa-eye';
        toggleBtn.classList.remove('active');
        this.showToast('Password hidden', 'info');
    }
};

ChangePassword.prototype.setupPasswordValidation = function() {
    var self = this;
    
    // New password validation
    if (this.newPasswordInput) {
        this.newPasswordInput.addEventListener('input', function() {
            self.validatePassword(this.value);
            self.checkPasswordMatch();
            self.updateRequirements();
        });
        
        this.newPasswordInput.addEventListener('blur', function() {
            self.validatePassword(this.value);
        });
    }
    
    // Confirm password validation
    if (this.confirmPasswordInput) {
        this.confirmPasswordInput.addEventListener('input', function() {
            self.checkPasswordMatch();
        });
        
        this.confirmPasswordInput.addEventListener('blur', function() {
            self.checkPasswordMatch();
        });
    }
};

ChangePassword.prototype.validatePassword = function(password) {
    var strength = this.calculatePasswordStrength(password);
    this.updatePasswordStrength(strength);
    return strength.score >= 3; // At least "good" strength
};

ChangePassword.prototype.calculatePasswordStrength = function(password) {
    var score = 0;
    var feedback = [];
    
    // Check length
    if (password.length >= 8) {
        score += 1;
    } else {
        feedback.push('At least 8 characters');
    }
    
    // Check uppercase letters
    if (/[A-Z]/.test(password)) {
        score += 1;
    } else {
        feedback.push('One uppercase letter');
    }
    
    // Check lowercase letters
    if (/[a-z]/.test(password)) {
        score += 1;
    } else {
        feedback.push('One lowercase letter');
    }
    
    // Check numbers
    if (/\d/.test(password)) {
        score += 1;
    } else {
        feedback.push('One number');
    }
    
    // Check special characters
    if (/[^A-Za-z0-9]/.test(password)) {
        score += 1;
    } else {
        feedback.push('One special character');
    }
    
    // Determine strength level
    var level, className;
    if (score === 0) {
        level = 'None';
        className = '';
    } else if (score <= 2) {
        level = 'Weak';
        className = 'weak';
    } else if (score === 3) {
        level = 'Fair';
        className = 'fair';
    } else if (score === 4) {
        level = 'Good';
        className = 'good';
    } else {
        level = 'Strong';
        className = 'strong';
    }
    
    return {
        score: score,
        level: level,
        className: className,
        feedback: feedback
    };
};

ChangePassword.prototype.updatePasswordStrength = function(strength) {
    if (!this.passwordStrength) return;
    
    var strengthBar = this.passwordStrength.querySelector('.strength-bar');
    var strengthText = this.passwordStrength.querySelector('.strength-text span');
    
    if (strength.score === 0) {
        this.passwordStrength.classList.remove('visible');
        strengthBar.className = 'strength-bar';
        strengthText.textContent = 'None';
        strengthText.className = '';
    } else {
        this.passwordStrength.classList.add('visible');
        strengthBar.className = 'strength-bar ' + strength.className;
        strengthText.textContent = strength.level;
        strengthText.className = strength.className;
    }
};

ChangePassword.prototype.checkPasswordMatch = function() {
    if (!this.passwordMatch || !this.newPasswordInput || !this.confirmPasswordInput) return;
    
    var newPassword = this.newPasswordInput.value;
    var confirmPassword = this.confirmPasswordInput.value;
    
    if (!newPassword || !confirmPassword) {
        this.passwordMatch.classList.remove('visible');
        return;
    }
    
    this.passwordMatch.classList.add('visible');
    
    if (newPassword === confirmPassword) {
        this.passwordMatch.className = 'password-match visible';
        this.passwordMatch.querySelector('i').className = 'fas fa-check-circle';
        this.passwordMatch.querySelector('span').textContent = 'Passwords match';
    } else {
        this.passwordMatch.className = 'password-match visible mismatch';
        this.passwordMatch.querySelector('i').className = 'fas fa-times-circle';
        this.passwordMatch.querySelector('span').textContent = 'Passwords do not match';
    }
};

ChangePassword.prototype.updateRequirements = function() {
    var password = this.newPasswordInput ? this.newPasswordInput.value : '';
    
    // Length requirement
    var reqLength = document.getElementById('reqLength');
    if (reqLength) {
        if (password.length >= 8) {
            reqLength.classList.add('met');
            reqLength.classList.remove('unmet');
        } else {
            reqLength.classList.add('unmet');
            reqLength.classList.remove('met');
        }
    }
    
    // Uppercase requirement
    var reqUppercase = document.getElementById('reqUppercase');
    if (reqUppercase) {
        if (/[A-Z]/.test(password)) {
            reqUppercase.classList.add('met');
            reqUppercase.classList.remove('unmet');
        } else {
            reqUppercase.classList.add('unmet');
            reqUppercase.classList.remove('met');
        }
    }
    
    // Lowercase requirement
    var reqLowercase = document.getElementById('reqLowercase');
    if (reqLowercase) {
        if (/[a-z]/.test(password)) {
            reqLowercase.classList.add('met');
            reqLowercase.classList.remove('unmet');
        } else {
            reqLowercase.classList.add('unmet');
            reqLowercase.classList.remove('met');
        }
    }
    
    // Number requirement
    var reqNumber = document.getElementById('reqNumber');
    if (reqNumber) {
        if (/\d/.test(password)) {
            reqNumber.classList.add('met');
            reqNumber.classList.remove('unmet');
        } else {
            reqNumber.classList.add('unmet');
            reqNumber.classList.remove('met');
        }
    }
    
    // Special character requirement
    var reqSpecial = document.getElementById('reqSpecial');
    if (reqSpecial) {
        if (/[^A-Za-z0-9]/.test(password)) {
            reqSpecial.classList.add('met');
            reqSpecial.classList.remove('unmet');
        } else {
            reqSpecial.classList.add('unmet');
            reqSpecial.classList.remove('met');
        }
    }
};

ChangePassword.prototype.setupFormValidation = function() {
    var self = this;
    
    if (this.form) {
        this.form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (self.validateForm()) {
                self.showConfirmation();
            }
        });
    }
    
    // Cancel button
    if (this.cancelBtn) {
        this.cancelBtn.addEventListener('click', function(e) {
            if (self.formHasChanges()) {
                e.preventDefault();
                if (confirm('You have unsaved changes. Are you sure you want to cancel?')) {
                    window.location.href = this.href;
                }
            }
        });
    }
};

ChangePassword.prototype.validateForm = function() {
    var isValid = true;
    var errors = [];
    
    // Validate new password
    var newPassword = this.newPasswordInput ? this.newPasswordInput.value : '';
    if (!newPassword) {
        errors.push('Please enter a new password');
        isValid = false;
        this.newPasswordInput.classList.add('invalid');
    } else if (newPassword.length < 8) {
        errors.push('Password must be at least 8 characters long');
        isValid = false;
        this.newPasswordInput.classList.add('invalid');
    } else {
        this.newPasswordInput.classList.remove('invalid');
    }
    
    // Validate password strength
    var strength = this.calculatePasswordStrength(newPassword);
    if (strength.score < 3) {
        errors.push('Password is too weak. Please use a stronger password.');
        isValid = false;
        this.newPasswordInput.classList.add('invalid');
    }
    
    // Validate password match
    var confirmPassword = this.confirmPasswordInput ? this.confirmPasswordInput.value : '';
    if (!confirmPassword) {
        errors.push('Please confirm your password');
        isValid = false;
        this.confirmPasswordInput.classList.add('invalid');
    } else if (newPassword !== confirmPassword) {
        errors.push('Passwords do not match');
        isValid = false;
        this.confirmPasswordInput.classList.add('invalid');
    } else {
        this.confirmPasswordInput.classList.remove('invalid');
    }
    
    // Show errors
    if (errors.length > 0) {
        this.showErrors(errors);
    }
    
    return isValid;
};

ChangePassword.prototype.formHasChanges = function() {
    var newPassword = this.newPasswordInput ? this.newPasswordInput.value : '';
    var confirmPassword = this.confirmPasswordInput ? this.confirmPasswordInput.value : '';
    
    return newPassword.length > 0 || confirmPassword.length > 0;
};

ChangePassword.prototype.showErrors = function(errors) {
    var self = this;
    
    errors.forEach(function(error) {
        self.showToast(error, 'error');
    });
    
    // Focus on first error field
    if (errors[0].includes('new password')) {
        this.newPasswordInput.focus();
    } else if (errors[0].includes('confirm')) {
        this.confirmPasswordInput.focus();
    }
};

ChangePassword.prototype.setupConfirmationModal = function() {
    var self = this;
    
    if (this.confirmationModal && this.confirmCancelBtn && this.confirmSubmitBtn) {
        // Cancel confirmation
        this.confirmCancelBtn.addEventListener('click', function() {
            self.hideModal(self.confirmationModal);
        });
        
        // Submit confirmation
        this.confirmSubmitBtn.addEventListener('click', function() {
            self.submitForm();
        });
        
        // Close on background click
        this.confirmationModal.addEventListener('click', function(e) {
            if (e.target === self.confirmationModal) {
                self.hideModal(self.confirmationModal);
            }
        });
    }
};

ChangePassword.prototype.showConfirmation = function() {
    if (this.confirmationModal) {
        this.showModal(this.confirmationModal);
    }
};

ChangePassword.prototype.hideModal = function(modal) {
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
};

ChangePassword.prototype.showModal = function(modal) {
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
};

ChangePassword.prototype.submitForm = function() {
    var self = this;
    
    if (this.confirmationModal) {
        this.hideModal(this.confirmationModal);
    }
    
    // Show loading state
    if (this.submitBtn) {
        this.submitBtn.disabled = true;
        this.submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Changing Password...';
    }
    
    // Submit the form
    setTimeout(function() {
        if (self.form) {
            self.form.submit();
        }
    }, 500);
};

ChangePassword.prototype.setupFadeAnimations = function() {
    var fadeElements = document.querySelectorAll('.fade-in');
    var self = this;
    
    fadeElements.forEach(function(element) {
        element.style.opacity = '0';
        element.style.transform = 'translateY(20px)';
        element.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        
        setTimeout(function() {
            element.style.opacity = '1';
            element.style.transform = 'translateY(0)';
        }, 100);
    });
    
    // Also fade in alerts if present
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        alert.style.animation = 'fadeIn 0.5s ease';
    });
};

ChangePassword.prototype.setupKeyboardShortcuts = function() {
    var self = this;
    
    document.addEventListener('keydown', function(e) {
        // Ctrl+Enter to submit form
        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
            e.preventDefault();
            if (self.form && self.validateForm()) {
                self.showConfirmation();
            }
        }
        
        // Escape to close modal or cancel
        if (e.key === 'Escape') {
            if (self.confirmationModal && self.confirmationModal.style.display === 'flex') {
                self.hideModal(self.confirmationModal);
            }
        }
        
        // Space to toggle password visibility when focused
        if (e.key === ' ' && (document.activeElement === self.newPasswordInput || 
                              document.activeElement === self.confirmPasswordInput)) {
            e.preventDefault();
            var toggleBtn = document.activeElement === self.newPasswordInput ? 
                           self.toggleNewPasswordBtn : self.toggleConfirmPasswordBtn;
            if (toggleBtn) {
                toggleBtn.click();
            }
        }
    });
};

ChangePassword.prototype.showToast = function(message, type) {
    var toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toastContainer';
        toastContainer.style.cssText = 'position: fixed; bottom: 20px; right: 20px; ' +
                                      'z-index: 9999; display: flex; flex-direction: column; gap: 10px;';
        document.body.appendChild(toastContainer);
        
        // Add CSS for toast animations if not present
        if (!document.querySelector('#toastStyles')) {
            var style = document.createElement('style');
            style.id = 'toastStyles';
            style.textContent = `
                @keyframes slideIn {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
                
                @keyframes slideOut {
                    from {
                        opacity: 1;
                        transform: translateY(0);
                    }
                    to {
                        opacity: 0;
                        transform: translateY(20px);
                    }
                }
                
                .toast {
                    background: white;
                    border-radius: 8px;
                    padding: 15px 20px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    min-width: 300px;
                    max-width: 400px;
                    opacity: 0;
                    transform: translateY(20px);
                    transition: all 0.3s ease;
                    border-left: 4px solid #3b82f6;
                }
                
                .toast.show {
                    opacity: 1;
                    transform: translateY(0);
                }
                
                .toast.hide {
                    opacity: 0;
                    transform: translateY(20px);
                }
                
                .toast.success {
                    border-left-color: #10b981;
                }
                
                .toast.error {
                    border-left-color: #ef4444;
                }
                
                .toast.info {
                    border-left-color: #3b82f6;
                }
                
                .toast.warning {
                    border-left-color: #f59e0b;
                }
                
                .toast-icon {
                    font-size: 1.2rem;
                }
                
                .toast.success .toast-icon {
                    color: #10b981;
                }
                
                .toast.error .toast-icon {
                    color: #ef4444;
                }
                
                .toast.info .toast-icon {
                    color: #3b82f6;
                }
                
                .toast.warning .toast-icon {
                    color: #f59e0b;
                }
                
                .toast-content {
                    flex: 1;
                }
                
                .toast-content p {
                    margin: 0;
                    color: #374151;
                    font-size: 0.9rem;
                }
                
                .toast-close {
                    background: none;
                    border: none;
                    color: #9ca3af;
                    cursor: pointer;
                    padding: 0;
                    font-size: 0.9rem;
                    transition: color 0.2s;
                }
                
                .toast-close:hover {
                    color: #374151;
                }
            `;
            document.head.appendChild(style);
        }
    }
    
    var toast = document.createElement('div');
    toast.className = 'toast ' + type;
    toast.innerHTML = `
        <div class="toast-icon">
            <i class="fas fa-${type === 'success' ? 'check-circle' : 
                              type === 'error' ? 'exclamation-circle' : 
                              type === 'warning' ? 'exclamation-triangle' : 'info-circle'}"></i>
        </div>
        <div class="toast-content">
            <p>${message}</p>
        </div>
        <button class="toast-close">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    toastContainer.appendChild(toast);
    
    // Add show animation
    setTimeout(function() {
        toast.classList.add('show');
    }, 10);
    
    // Auto remove after 5 seconds
    var removeTimeout = setTimeout(function() {
        toast.classList.remove('show');
        toast.classList.add('hide');
        setTimeout(function() {
            if (toast.parentNode === toastContainer) {
                toast.remove();
            }
        }, 300);
    }, 5000);
    
    // Close button functionality
    toast.querySelector('.toast-close').addEventListener('click', function() {
        clearTimeout(removeTimeout);
        toast.classList.remove('show');
        toast.classList.add('hide');
        setTimeout(function() {
            if (toast.parentNode === toastContainer) {
                toast.remove();
            }
        }, 300);
    });
};

// Add fade-in animation CSS if not present
if (!document.querySelector('#fadeAnimations')) {
    var fadeStyle = document.createElement('style');
    fadeStyle.id = 'fadeAnimations';
    fadeStyle.textContent = `
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .alert {
            animation: fadeIn 0.5s ease;
        }
    `;
    document.head.appendChild(fadeStyle);
}

// Initialize the change password manager
document.addEventListener('DOMContentLoaded', function() {
    // Check if we're on the change password page
    if (document.querySelector('.change-password-form')) {
        new ChangePassword();
    }
});