/**
 * Profile Management
 * Enhanced with avatar upload and interactive features
 * @class ProfileManager
 * @version 1.0.0
 */

/* global document, window, localStorage, console */

function ProfileManager() {
    this.avatarUpload = document.getElementById('avatarUpload');
    this.avatarOverlay = document.getElementById('avatarOverlay');
    this.profileAvatar = document.getElementById('profileAvatar');
    this.avatarPlaceholder = document.getElementById('avatarPlaceholder');
    this.currentUserId = null;
    
    this.init();
}

ProfileManager.prototype.init = function() {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', this.setup.bind(this));
    } else {
        this.setup();
    }
};

ProfileManager.prototype.setup = function() {
    this.setupAvatarUpload();
    this.setupButtons();
    this.setupModals();
    this.setupStatistics();
    this.setupKeyboardShortcuts();
    this.loadProfileStats();
};

ProfileManager.prototype.setupAvatarUpload = function() {
    var self = this;
    
    // Avatar overlay click
    if (this.avatarOverlay) {
        this.avatarOverlay.addEventListener('click', function() {
            self.showAvatarUploadModal();
        });
    }
    
    // Direct file input
    if (this.avatarUpload) {
        this.avatarUpload.addEventListener('change', function(e) {
            if (this.files && this.files[0]) {
                self.handleAvatarUpload(this.files[0]);
            }
        });
    }
};

ProfileManager.prototype.showAvatarUploadModal = function() {
    var modal = document.getElementById('avatarUploadModal');
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        
        // Setup modal event listeners
        this.setupAvatarModal();
    }
};

ProfileManager.prototype.setupAvatarModal = function() {
    var self = this;
    var modal = document.getElementById('avatarUploadModal');
    var modalClose = document.getElementById('avatarModalClose');
    var uploadFromComputer = document.getElementById('uploadFromComputer');
    var takePhoto = document.getElementById('takePhoto');
    var removePhoto = document.getElementById('removePhoto');
    var cancelCrop = document.getElementById('cancelCrop');
    var savePhoto = document.getElementById('savePhoto');
    
    // Close modal
    if (modalClose) {
        modalClose.addEventListener('click', function() {
            self.hideModal(modal);
        });
    }
    
    // Close on background click
    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            self.hideModal(modal);
        }
    });
    
    // Upload from computer
    if (uploadFromComputer) {
        uploadFromComputer.addEventListener('click', function() {
            self.avatarUpload.click();
            self.hideModal(modal);
        });
    }
    
    // Take photo (simulated - would use WebRTC in real implementation)
    if (takePhoto) {
        takePhoto.addEventListener('click', function() {
            self.showToast('Camera access would be requested here', 'info');
            self.hideModal(modal);
        });
    }
    
    // Remove photo
    if (removePhoto) {
        removePhoto.addEventListener('click', function() {
            self.removeAvatar();
            self.hideModal(modal);
        });
    }
    
    // Cancel crop
    if (cancelCrop) {
        cancelCrop.addEventListener('click', function() {
            var preview = document.getElementById('uploadPreview');
            if (preview) {
                preview.style.display = 'none';
            }
        });
    }
    
    // Save photo
    if (savePhoto) {
        savePhoto.addEventListener('click', function() {
            self.saveAvatar();
        });
    }
};

ProfileManager.prototype.handleAvatarUpload = function(file) {
    var self = this;
    
    // Validate file type
    var validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (validTypes.indexOf(file.type) === -1) {
        this.showToast('Invalid file type. Please upload JPEG, PNG, GIF, or WebP.', 'error');
        return;
    }
    
    // Validate file size (2MB)
    if (file.size > 2 * 1024 * 1024) {
        this.showToast('File size exceeds 2MB limit.', 'error');
        return;
    }
    
    // Show loading
    this.showLoading();
    
    // In real implementation, this would upload to server
    // For now, we'll simulate with localStorage and show preview
    var reader = new FileReader();
    
    reader.onload = function(e) {
        // Save to localStorage (temporary)
        var avatarData = {
            data: e.target.result,
            timestamp: new Date().toISOString(),
            filename: file.name
        };
        
        localStorage.setItem('profileAvatar', JSON.stringify(avatarData));
        
        // Update avatar preview
        if (self.profileAvatar) {
            self.profileAvatar.src = e.target.result;
        } else if (self.avatarPlaceholder) {
            self.avatarPlaceholder.style.display = 'none';
            var img = document.createElement('img');
            img.src = e.target.result;
            img.alt = 'Profile Avatar';
            img.className = 'profile-avatar';
            img.id = 'profileAvatar';
            self.avatarPlaceholder.parentNode.insertBefore(img, self.avatarPlaceholder);
            self.profileAvatar = img;
        }
        
        self.hideLoading();
        self.showToast('Profile photo updated successfully', 'success');
    };
    
    reader.onerror = function() {
        self.hideLoading();
        self.showToast('Error reading file', 'error');
    };
    
    reader.readAsDataURL(file);
};

ProfileManager.prototype.removeAvatar = function() {
    var self = this;
    
    // Show confirmation
    if (confirm('Are you sure you want to remove your profile photo?')) {
        // Remove from localStorage
        localStorage.removeItem('profileAvatar');
        
        // Reset to placeholder
        if (this.profileAvatar) {
            this.profileAvatar.remove();
            this.profileAvatar = null;
        }
        
        if (this.avatarPlaceholder) {
            this.avatarPlaceholder.style.display = 'flex';
        }
        
        this.showToast('Profile photo removed', 'info');
    }
};

ProfileManager.prototype.saveAvatar = function() {
    // In real implementation, this would save to server
    // For now, just close the modal
    var modal = document.getElementById('avatarUploadModal');
    this.hideModal(modal);
    this.showToast('Profile photo saved', 'success');
};

ProfileManager.prototype.setupButtons = function() {
    var self = this;
    
    // Edit Profile Button
    var editProfileBtn = document.getElementById('editProfileBtn');
    if (editProfileBtn) {
        editProfileBtn.addEventListener('click', function() {
            window.location.href = '<%= contextPath %>/seeker/editProfile';
        });
    }
    
    // Change Password Button
    var changePasswordBtn = document.getElementById('changePasswordBtn');
    if (changePasswordBtn) {
        changePasswordBtn.addEventListener('click', function() {
            window.location.href = '<%= contextPath %>/seeker/changePassword';
        });
    }
    
    // Download Profile Button
    var downloadProfileBtn = document.getElementById('downloadProfileBtn');
    if (downloadProfileBtn) {
        downloadProfileBtn.addEventListener('click', function() {
            self.exportProfileData();
        });
    }
    
    // Edit Personal Info Button
    var editPersonalInfo = document.getElementById('editPersonalInfo');
    if (editPersonalInfo) {
        editPersonalInfo.addEventListener('click', function() {
            window.location.href = '<%= contextPath %>/seeker/editProfile';
        });
    }
    
    // Deactivate Account Button
    var deactivateAccount = document.getElementById('deactivateAccount');
    if (deactivateAccount) {
        deactivateAccount.addEventListener('click', function() {
            self.showDeactivateModal();
        });
    }
};

ProfileManager.prototype.setupModals = function() {
    var self = this;
    
    // Deactivate Account Modal
    var deactivateModal = document.getElementById('deactivateModal');
    var cancelDeactivate = document.getElementById('cancelDeactivate');
    var confirmDeactivate = document.getElementById('confirmDeactivate');
    
    if (cancelDeactivate) {
        cancelDeactivate.addEventListener('click', function() {
            self.hideModal(deactivateModal);
        });
    }
    
    if (confirmDeactivate) {
        confirmDeactivate.addEventListener('click', function() {
            self.deactivateAccount();
        });
    }
    
    if (deactivateModal) {
        deactivateModal.addEventListener('click', function(e) {
            if (e.target === deactivateModal) {
                self.hideModal(deactivateModal);
            }
        });
    }
};

ProfileManager.prototype.showDeactivateModal = function() {
    var modal = document.getElementById('deactivateModal');
    this.showModal(modal);
};

ProfileManager.prototype.deactivateAccount = function() {
    var self = this;
    var modal = document.getElementById('deactivateModal');
    
    // Show loading
    this.showLoading();
    
    // Simulate API call
    setTimeout(function() {
        self.hideLoading();
        self.hideModal(modal);
        
        // In real implementation, this would call the backend
        // For now, show success message
        self.showToast('Account deactivation request sent. You will be logged out.', 'info');
        
        // Redirect to logout after delay
        setTimeout(function() {
            window.location.href = '<%= contextPath %>/logout';
        }, 2000);
    }, 1500);
};

ProfileManager.prototype.setupStatistics = function() {
    // Initialize stats from localStorage or defaults
    this.loadProfileStats();
};

ProfileManager.prototype.loadProfileStats = function() {
    // Load statistics from localStorage or set defaults
    var stats = JSON.parse(localStorage.getItem('profileStats')) || {
        applicationsCount: 0,
        profileViews: 0,
        savedJobs: 0,
        activeDays: 1,
        lastLogin: new Date().toLocaleDateString(),
        passwordChanged: '1 month ago'
    };
    
    // Update UI
    var applicationsCount = document.getElementById('applicationsCount');
    var profileViews = document.getElementById('profileViews');
    var savedJobs = document.getElementById('savedJobs');
    var activeDays = document.getElementById('activeDays');
    var lastLogin = document.getElementById('lastLogin');
    var passwordChanged = document.getElementById('passwordChanged');
    
    if (applicationsCount) applicationsCount.textContent = stats.applicationsCount;
    if (profileViews) profileViews.textContent = stats.profileViews;
    if (savedJobs) savedJobs.textContent = stats.savedJobs;
    if (activeDays) activeDays.textContent = stats.activeDays;
    if (lastLogin) lastLogin.textContent = stats.lastLogin;
    if (passwordChanged) passwordChanged.textContent = stats.passwordChanged;
};

ProfileManager.prototype.exportProfileData = function() {
    var self = this;
    
    // Show loading
    this.showLoading();
    
    // Collect profile data
    var profileData = {
        name: document.getElementById('displayName') ? document.getElementById('displayName').textContent : '',
        email: document.getElementById('displayEmail') ? document.getElementById('displayEmail').textContent : '',
        phone: document.getElementById('displayPhone') ? document.getElementById('displayPhone').textContent : '',
        status: '<%= u.getStatus() %>',
        exportDate: new Date().toISOString(),
        statistics: JSON.parse(localStorage.getItem('profileStats')) || {}
    };
    
    // Create JSON file
    var dataStr = JSON.stringify(profileData, null, 2);
    var dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
    
    setTimeout(function() {
        self.hideLoading();
        
        // Create download link
        var exportFileDefaultName = 'profile-data-' + new Date().getTime() + '.json';
        var linkElement = document.createElement('a');
        linkElement.setAttribute('href', dataUri);
        linkElement.setAttribute('download', exportFileDefaultName);
        linkElement.click();
        
        self.showToast('Profile data exported successfully', 'success');
    }, 1000);
};

ProfileManager.prototype.setupKeyboardShortcuts = function() {
    var self = this;
    
    document.addEventListener('keydown', function(e) {
        // Escape to close modals
        if (e.key === 'Escape') {
            var avatarModal = document.getElementById('avatarUploadModal');
            var deactivateModal = document.getElementById('deactivateModal');
            
            if (avatarModal && avatarModal.style.display === 'flex') {
                self.hideModal(avatarModal);
            }
            if (deactivateModal && deactivateModal.style.display === 'flex') {
                self.hideModal(deactivateModal);
            }
        }
        
        // Ctrl+E to edit profile
        if ((e.ctrlKey || e.metaKey) && e.key === 'e') {
            e.preventDefault();
            window.location.href = '<%= contextPath %>/seeker/editProfile';
        }
        
        // Ctrl+S to export profile
        if ((e.ctrlKey || e.metaKey) && e.key === 's') {
            e.preventDefault();
            self.exportProfileData();
        }
    });
};

ProfileManager.prototype.showModal = function(modal) {
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
};

ProfileManager.prototype.hideModal = function(modal) {
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
};

ProfileManager.prototype.showLoading = function() {
    var loadingOverlay = document.getElementById('loadingOverlay');
    if (loadingOverlay) {
        loadingOverlay.style.display = 'flex';
    }
};

ProfileManager.prototype.hideLoading = function() {
    var loadingOverlay = document.getElementById('loadingOverlay');
    if (loadingOverlay) {
        loadingOverlay.style.display = 'none';
    }
};

ProfileManager.prototype.showToast = function(message, type) {
    var toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) return;
    
    var toast = document.createElement('div');
    toast.className = 'toast ' + type;
    toast.innerHTML = `
        <div class="toast-icon">
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
        </div>
        <div class="toast-content">
            <p>${message}</p>
        </div>
        <button class="toast-close">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    toastContainer.appendChild(toast);
    
    // Add animation
    setTimeout(function() {
        toast.classList.add('show');
    }, 10);
    
    // Auto remove after 5 seconds
    setTimeout(function() {
        toast.classList.remove('show');
        setTimeout(function() {
            toast.remove();
        }, 300);
    }, 5000);
    
    // Close button functionality
    toast.querySelector('.toast-close').addEventListener('click', function() {
        toast.classList.remove('show');
        setTimeout(function() {
            toast.remove();
        }, 300);
    });
};

// Initialize the profile manager
document.addEventListener('DOMContentLoaded', function() {
    new ProfileManager();
});