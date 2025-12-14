/**
 * System Settings Management
 * Enhanced with modern features and animations
 */

class SystemSettings {
    constructor() {
        this.currentTheme = localStorage.getItem('adminTheme') || 'light';
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
        this.setupTheme();
        this.setupFormValidation();
        this.setupAnimations();
        this.setupLoading();
        this.setupNotifications();
        this.setupFloatingElements();
        this.setupInputEffects();
    }

    setupTheme() {
        const themeToggle = document.getElementById('themeToggle');
        
        // Apply saved theme
        if (this.currentTheme === 'dark') {
            document.body.classList.add('dark');
            this.updateThemeButton('light');
        } else {
            document.body.classList.remove('dark');
            this.updateThemeButton('dark');
        }
        
        if (themeToggle) {
            themeToggle.addEventListener('click', () => this.toggleTheme());
        }
    }

    toggleTheme() {
        const body = document.body;
        const themeToggle = document.getElementById('themeToggle');
        
        if (body.classList.contains('dark')) {
            body.classList.remove('dark');
            localStorage.setItem('adminTheme', 'light');
            this.currentTheme = 'light';
            this.updateThemeButton('dark');
            this.showToast('Light mode enabled', 'info');
        } else {
            body.classList.add('dark');
            localStorage.setItem('adminTheme', 'dark');
            this.currentTheme = 'dark';
            this.updateThemeButton('light');
            this.showToast('Dark mode enabled', 'info');
        }
    }

    updateThemeButton(targetTheme) {
        const themeToggle = document.getElementById('themeToggle');
        if (!themeToggle) return;
        
        if (targetTheme === 'light') {
            themeToggle.innerHTML = '<i class="fas fa-sun"></i><span>Light Mode</span>';
        } else {
            themeToggle.innerHTML = '<i class="fas fa-moon"></i><span>Dark Mode</span>';
        }
    }

    setupFormValidation() {
        const form = document.querySelector('.settings-form');
        if (!form) return;

        form.addEventListener('submit', (e) => {
            e.preventDefault();
            
            // Get form data
            const formData = new FormData(form);
            const data = Object.fromEntries(formData);
            
            // Validate required fields
            const errors = this.validateForm(data);
            
            if (Object.keys(errors).length > 0) {
                this.showValidationErrors(errors);
                return;
            }
            
            // Show loading and submit
            this.showLoading();
            
            // Simulate API call
            setTimeout(() => {
                this.hideLoading();
                
                // Show success message
                this.showToast('Settings saved successfully!', 'success');
                
                // Add success animation to form
                form.classList.add('success-animation');
                setTimeout(() => form.classList.remove('success-animation'), 1000);
                
                // Actually submit the form
                form.submit();
            }, 1500);
        });
    }

    validateForm(data) {
        const errors = {};
        
        // Validate site name
        if (!data.site_name || data.site_name.trim().length < 2) {
            errors.site_name = 'Site name must be at least 2 characters';
        }
        
        // Validate admin email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!data.admin_email || !emailRegex.test(data.admin_email)) {
            errors.admin_email = 'Please enter a valid email address';
        }
        
        return errors;
    }

    showValidationErrors(errors) {
        // Remove existing error messages
        const existingErrors = document.querySelectorAll('.error-message');
        existingErrors.forEach(error => error.remove());
        
        // Remove error classes
        const inputs = document.querySelectorAll('.form-control, .form-select');
        inputs.forEach(input => input.classList.remove('error'));
        
        // Add new error messages
        Object.keys(errors).forEach(fieldName => {
            const input = document.querySelector(`[name="${fieldName}"]`);
            if (input) {
                input.classList.add('error');
                
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${errors[fieldName]}`;
                errorDiv.style.cssText = `
                    color: var(--danger);
                    font-size: 0.9rem;
                    margin-top: 5px;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    animation: slideIn 0.3s ease;
                `;
                
                input.parentNode.appendChild(errorDiv);
                
                // Add shake animation
                input.style.animation = 'shake 0.5s ease';
                setTimeout(() => input.style.animation = '', 500);
            }
        });
        
        this.showToast('Please fix the errors in the form', 'error');
    }

    setupAnimations() {
        // Add hover animations to cards
        const cards = document.querySelectorAll('.settings-card, .alert');
        cards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
            card.classList.add('fade-in');
            
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'translateY(-5px)';
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0)';
            });
        });
        
        // Add floating animation to page icon
        const pageIcon = document.querySelector('.page-icon');
        if (pageIcon) {
            pageIcon.style.animation = 'float 6s infinite ease-in-out';
        }
        
        // Add custom animations CSS
        const style = document.createElement('style');
        style.textContent = `
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
                20%, 40%, 60%, 80% { transform: translateX(5px); }
            }
            
            @keyframes successAnimation {
                0% { transform: scale(1); }
                50% { transform: scale(1.02); }
                100% { transform: scale(1); }
            }
            
            .success-animation {
                animation: successAnimation 0.5s ease;
            }
            
            .error {
                border-color: var(--danger) !important;
                background: rgba(239, 68, 68, 0.05) !important;
            }
            
            /* Custom scrollbar */
            ::-webkit-scrollbar {
                width: 10px;
            }
            
            ::-webkit-scrollbar-track {
                background: var(--bg-secondary);
                border-radius: var(--radius-full);
            }
            
            ::-webkit-scrollbar-thumb {
                background: var(--border-medium);
                border-radius: var(--radius-full);
            }
            
            ::-webkit-scrollbar-thumb:hover {
                background: var(--primary-light);
            }
            
            ::selection {
                background-color: rgba(37, 99, 235, 0.3);
                color: var(--text-primary);
            }
        `;
        document.head.appendChild(style);
    }

    setupLoading() {
        // Create loading overlay if not exists
        let overlay = document.getElementById('loadingOverlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.id = 'loadingOverlay';
            overlay.className = 'loading-overlay';
            overlay.innerHTML = `
                <div class="loading-spinner">
                    <i class="fas fa-cog fa-spin"></i>
                    <p>Saving Settings...</p>
                </div>
            `;
            document.body.appendChild(overlay);
        }
        
        this.showLoading = () => {
            overlay.style.display = 'flex';
        };
        
        this.hideLoading = () => {
            overlay.style.display = 'none';
        };
    }

    setupNotifications() {
        // Create toast container if not exists
        let container = document.getElementById('toastContainer');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toastContainer';
            container.className = 'toast-container';
            document.body.appendChild(container);
        }
    }

    showToast(message, type = 'info') {
        const container = document.getElementById('toastContainer');
        if (!container) return;
        
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        
        // Set icon based on type
        let icon = 'info-circle';
        if (type === 'success') icon = 'check-circle';
        if (type === 'error') icon = 'exclamation-circle';
        if (type === 'warning') icon = 'exclamation-triangle';
        
        toast.innerHTML = `
            <i class="fas fa-${icon}"></i>
            <span>${message}</span>
            <button class="toast-close"><i class="fas fa-times"></i></button>
        `;
        
        // Add animation
        toast.style.animation = 'slideInRight 0.3s ease';
        
        // Close button
        const closeBtn = toast.querySelector('.toast-close');
        closeBtn.addEventListener('click', () => {
            toast.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.remove();
                }
            }, 300);
        });
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (toast.parentNode) {
                toast.style.animation = 'slideOut 0.3s ease forwards';
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.remove();
                    }
                }, 300);
            }
        }, 5000);
        
        container.appendChild(toast);
        
        // Limit number of toasts
        const toasts = container.querySelectorAll('.toast');
        if (toasts.length > 3) {
            toasts[0].remove();
        }
    }

    setupFloatingElements() {
        // Add floating background elements if not exists
        if (!document.querySelector('.floating-element')) {
            const container = document.createElement('div');
            container.innerHTML = `
                <div class="floating-element"></div>
                <div class="floating-element"></div>
                <div class="floating-element"></div>
                <div class="hero-image"></div>
                <div class="hero-overlay"></div>
            `;
            document.body.insertBefore(container, document.body.firstChild);
        }
    }

    setupInputEffects() {
        const inputs = document.querySelectorAll('.form-control, .form-select');
        
        inputs.forEach(input => {
            // Focus effect
            input.addEventListener('focus', () => {
                input.style.boxShadow = '0 0 0 4px rgba(37, 99, 235, 0.1)';
                input.style.borderColor = 'var(--primary)';
                input.style.transform = 'translateY(-2px)';
            });
            
            // Blur effect
            input.addEventListener('blur', () => {
                input.style.boxShadow = 'none';
                input.style.borderColor = 'var(--border-light)';
                input.style.transform = 'translateY(0)';
            });
            
            // Change effect
            input.addEventListener('change', () => {
                if (input.value.trim() !== '') {
                    input.classList.add('has-value');
                } else {
                    input.classList.remove('has-value');
                }
            });
            
            // Add initial check for values
            if (input.value.trim() !== '') {
                input.classList.add('has-value');
            }
        });
    }

    resetForm() {
        const form = document.querySelector('.settings-form');
        if (form) {
            form.reset();
            this.showToast('Form reset to default values', 'info');
            
            // Remove error messages
            const errors = document.querySelectorAll('.error-message');
            errors.forEach(error => error.remove());
            
            // Remove error classes
            const inputs = document.querySelectorAll('.error');
            inputs.forEach(input => input.classList.remove('error'));
        }
    }

    exportSettings() {
        this.showLoading();
        
        setTimeout(() => {
            this.hideLoading();
            
            const form = document.querySelector('.settings-form');
            const data = new FormData(form);
            const json = Object.fromEntries(data);
            
            // Create and download JSON file
            const blob = new Blob([JSON.stringify(json, null, 2)], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `system_settings_${new Date().toISOString().split('T')[0]}.json`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
            
            this.showToast('Settings exported successfully', 'success');
        }, 1000);
    }
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.systemSettingsApp = new SystemSettings();
});

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { SystemSettings };
}