/**
 * Edit Profile Management
 * Enhanced with form validation, avatar preview, and interactive features
 * @class EditProfile
 * @version 1.0.0
 */

/* global document, window, localStorage, console */

function EditProfile() {
    this.form = document.querySelector('.edit-profile-form');
    this.avatarInput = document.getElementById('avatarInput');
    this.avatarPreview = document.getElementById('avatarPreview');
    this.noAvatar = document.getElementById('noAvatar');
    this.fileName = document.getElementById('fileName');
    this.nameInput = document.querySelector('input[name="name"]');
    this.emailInput = document.querySelector('input[name="email"]');
    this.phoneInput = document.querySelector('input[name="phone"]');
    this.submitBtn = this.form ? this.form.querySelector('button[type="submit"]') : null;
    this.themeToggle = document.getElementById('themeToggle');
    
    this.init();
}

EditProfile.prototype.init = function() {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', this.setup.bind(this));
    } else {
        this.setup();
    }
};

EditProfile.prototype.setup = function() {
    this.setupThemeToggle();
    this.setupAvatarUpload();
    this.setupFormValidation();
    this.setupFadeAnimations();
    this.setupKeyboardShortcuts();
    this.loadSavedAvatar();
};

EditProfile.prototype.setupThemeToggle = function() {
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

EditProfile.prototype.toggleTheme = function() {
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

EditProfile.prototype.setupAvatarUpload = function() {
    var self = this;
    
    if (this.avatarInput && this.fileName) {
        this.avatarInput.addEventListener('change', function(e) {
            if (this.files && this.files[0]) {
                self.handleAvatarSelection(this.files[0]);
            } else {
                self.fileName.textContent = 'No file chosen';
            }
        });
        
        // Drag and drop support for avatar upload
        var fileInputLabel = this.avatarInput.closest('.file-input-container');
        if (fileInputLabel) {
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(function(eventName) {
                fileInputLabel.addEventListener(eventName, function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                });
            });
            
            ['dragenter', 'dragover'].forEach(function(eventName) {
                fileInputLabel.addEventListener(eventName, function() {
                    fileInputLabel.style.borderColor = 'var(--primary)';
                    fileInputLabel.style.background = 'rgba(37, 99, 235, 0.05)';
                });
            });
            
            ['dragleave', 'drop'].forEach(function(eventName) {
                fileInputLabel.addEventListener(eventName, function() {
                    fileInputLabel.style.borderColor = '';
                    fileInputLabel.style.background = '';
                });
            });
            
            fileInputLabel.addEventListener('drop', function(e) {
                var files = e.dataTransfer.files;
                if (files && files[0]) {
                    self.handleAvatarSelection(files[0]);
                    self.avatarInput.files = files;
                }
            });
        }
    }
};

EditProfile.prototype.handleAvatarSelection = function(file) {
    // Validate file type
    var validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (validTypes.indexOf(file.type) === -1) {
        this.showToast('Invalid file type. Please upload JPEG, PNG, GIF, or WebP.', 'error');
        this.avatarInput.value = '';
        this.fileName.textContent = 'No file chosen';
        return;
    }
    
    // Validate file size (2MB)
    if (file.size > 2 * 1024 * 1024) {
        this.showToast('File size exceeds 2MB limit. Please choose a smaller file.', 'error');
        this.avatarInput.value = '';
        this.fileName.textContent = 'No file chosen';
        return;
    }
    
    // Update file info
    this.fileName.textContent = file.name + ' (' + this.formatFileSize(file.size) + ')';
    
    // Preview image
    var reader = new FileReader();
    var self = this;
    
    reader.onload = function(e) {
        self.updateAvatarPreview(e.target.result);
        self.saveAvatarToLocalStorage(e.target.result, file.name);
        self.showToast('Image selected. Click Save Changes to update.', 'info');
    };
    
    reader.onerror = function() {
        self.showToast('Error reading file', 'error');
    };
    
    reader.readAsDataURL(file);
};

EditProfile.prototype.updateAvatarPreview = function(imageData) {
    if (this.avatarPreview) {
        this.avatarPreview.src = imageData;
    } else if (this.noAvatar) {
        this.noAvatar.style.display = 'none';
        var img = document.createElement('img');
        img.src = imageData;
        img.alt = 'New Avatar Preview';
        img.className = 'avatar-preview';
        img.id = 'avatarPreview';
        this.noAvatar.parentNode.insertBefore(img, this.noAvatar);
        this.avatarPreview = img;
    }
};

EditProfile.prototype.formatFileSize = function(bytes) {
    if (bytes === 0) return '0 Bytes';
    var k = 1024;
    var sizes = ['Bytes', 'KB', 'MB', 'GB'];
    var i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

EditProfile.prototype.saveAvatarToLocalStorage = function(imageData, filename) {
    var avatarData = {
        data: imageData,
        filename: filename,
        timestamp: new Date().toISOString()
    };
    localStorage.setItem('pendingAvatar', JSON.stringify(avatarData));
};

EditProfile.prototype.loadSavedAvatar = function() {
    var savedAvatar = localStorage.getItem('pendingAvatar');
    if (savedAvatar && this.avatarInput) {
        try {
            var avatarData = JSON.parse(savedAvatar);
            this.updateAvatarPreview(avatarData.data);
            this.fileName.textContent = avatarData.filename + ' (saved from previous session)';
            this.showToast('Loaded unsaved avatar from previous session', 'info');
        } catch (e) {
            console.error('Error loading saved avatar:', e);
        }
    }
};

EditProfile.prototype.setupFormValidation = function() {
    var self = this;
    
    if (this.form) {
        this.form.addEventListener('submit', function(e) {
            if (!self.validateForm()) {
                e.preventDefault();
            } else {
                self.handleFormSubmission();
            }
        });
        
        // Real-time validation for phone field
        if (this.phoneInput) {
            this.phoneInput.addEventListener('input', function() {
                self.validatePhoneField(this);
            });
            
            this.phoneInput.addEventListener('blur', function() {
                self.validatePhoneField(this);
            });
        }
        
        // Real-time validation for name field
        if (this.nameInput) {
            this.nameInput.addEventListener('input', function() {
                self.validateNameField(this);
            });
        }
    }
};

EditProfile.prototype.validateForm = function() {
    var isValid = true;
    var errors = [];
    
    // Validate name
    if (!this.nameInput || !this.nameInput.value.trim()) {
        errors.push('Please enter your name');
        isValid = false;
        this.nameInput.style.borderColor = 'var(--danger)';
    } else {
        this.nameInput.style.borderColor = '';
    }
    
    // Validate phone (if provided)
    if (this.phoneInput && this.phoneInput.value.trim()) {
        if (!this.isValidPhone(this.phoneInput.value)) {
            errors.push('Please enter a valid phone number');
            isValid = false;
            this.phoneInput.style.borderColor = 'var(--danger)';
        } else {
            this.phoneInput.style.borderColor = '';
        }
    }
    
    // Validate avatar file (if selected)
    if (this.avatarInput && this.avatarInput.files && this.avatarInput.files[0]) {
        var file = this.avatarInput.files[0];
        var validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        
        if (validTypes.indexOf(file.type) === -1) {
            errors.push('Avatar must be an image (JPEG, PNG, GIF, or WebP)');
            isValid = false;
        }
        
        if (file.size > 2 * 1024 * 1024) {
            errors.push('Avatar file size must be less than 2MB');
            isValid = false;
        }
    }
    
    // Show errors
    if (errors.length > 0) {
        this.showErrors(errors);
    }
    
    return isValid;
};

EditProfile.prototype.validatePhoneField = function(input) {
    if (input.value.trim() && !this.isValidPhone(input.value)) {
        input.style.borderColor = 'var(--danger)';
        this.showTooltip(input, 'Please enter a valid phone number (e.g., +1 1234567890)');
        return false;
    } else {
        input.style.borderColor = '';
        this.hideTooltip();
        return true;
    }
};

EditProfile.prototype.validateNameField = function(input) {
    if (!input.value.trim()) {
        input.style.borderColor = 'var(--danger)';
        return false;
    } else if (input.value.trim().length < 2) {
        input.style.borderColor = 'var(--warning)';
        return false;
    } else {
        input.style.borderColor = '';
        return true;
    }
};

EditProfile.prototype.isValidPhone = function(phone) {
    // Allow various phone formats
    var phoneRegex = /^[+]?[0-9\s\-\(\)]{10,}$/;
    return phoneRegex.test(phone);
};

EditProfile.prototype.showErrors = function(errors) {
    var self = this;
    
    errors.forEach(function(error) {
        self.showToast(error, 'error');
    });
    
    // Scroll to first error field
    if (this.nameInput && !this.nameInput.value.trim()) {
        this.nameInput.focus();
    } else if (this.phoneInput && this.phoneInput.value.trim() && !this.isValidPhone(this.phoneInput.value)) {
        this.phoneInput.focus();
    }
};

EditProfile.prototype.handleFormSubmission = function() {
    // Clear pending avatar from localStorage
    localStorage.removeItem('pendingAvatar');
    
    // Show loading state
    if (this.submitBtn) {
        this.submitBtn.disabled = true;
        this.submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving Changes...';
    }
    
    // Add a small delay to show loading state
    setTimeout(function() {
        // Form will submit normally after validation
    }, 100);
};

EditProfile.prototype.setupFadeAnimations = function() {
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

EditProfile.prototype.setupKeyboardShortcuts = function() {
    var self = this;
    
    document.addEventListener('keydown', function(e) {
        // Ctrl+S or Cmd+S to save form
        if ((e.ctrlKey || e.metaKey) && e.key === 's') {
            e.preventDefault();
            if (self.form && self.validateForm()) {
                self.form.submit();
            }
        }
        
        // Escape to reset form
        if (e.key === 'Escape') {
            if (confirm('Discard changes?')) {
                window.location.href = '<%= contextPath %>/seeker/profile';
            }
        }
        
        // Ctrl+Enter to submit form
        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
            e.preventDefault();
            if (self.form && self.validateForm()) {
                self.form.submit();
            }
        }
    });
};

EditProfile.prototype.showTooltip = function(element, message) {
    // Remove existing tooltip
    this.hideTooltip();
    
    // Create new tooltip
    var tooltip = document.createElement('div');
    tooltip.className = 'form-tooltip';
    tooltip.textContent = message;
    tooltip.style.cssText = 'position: absolute; background: rgba(0,0,0,0.8); ' +
                           'color: white; padding: 8px 12px; border-radius: 4px; ' +
                           'font-size: 0.85rem; z-index: 1000; white-space: nowrap; ' +
                           'top: ' + (element.offsetTop - 35) + 'px; ' +
                           'left: ' + element.offsetLeft + 'px;';
    
    tooltip.id = 'currentTooltip';
    document.body.appendChild(tooltip);
};

EditProfile.prototype.hideTooltip = function() {
    var tooltip = document.getElementById('currentTooltip');
    if (tooltip) {
        tooltip.remove();
    }
};

EditProfile.prototype.showToast = function(message, type) {
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
        
        .form-tooltip {
            animation: fadeIn 0.2s ease;
        }
    `;
    document.head.appendChild(fadeStyle);
}

// Initialize the edit profile manager
document.addEventListener('DOMContentLoaded', function() {
    // Check if we're on the edit profile page
    if (document.querySelector('.edit-profile-form')) {
        new EditProfile();
    }
});