


/**
 * Apply Job Management
 * Enhanced with form validation and interactive features
 * @class ApplyJob
 * @version 1.0.0
 */

/* global document, window, localStorage, console */

function ApplyJob() {
    this.form = document.getElementById('applicationForm');
    this.messageInput = document.getElementById('message');
    this.cvInput = document.getElementById('cvInput');
    this.uploadArea = document.getElementById('uploadArea');
    this.filePreview = document.getElementById('filePreview');
    this.charCount = document.getElementById('charCount');
    this.submitBtn = document.getElementById('submitBtn');
    this.isSubmitting = false;
    this.fileUploaded = false;
    this.currentFileName = '';
    this.currentFileSize = '';
    
    this.init();
}

ApplyJob.prototype.init = function() {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', this.setup.bind(this));
    } else {
        this.setup();
    }
};

ApplyJob.prototype.setup = function() {
    this.setupFormValidation();
    this.setupMessageInput();
    this.setupFileUpload();
    this.setupChecklist();
    this.setupConfirmationModal();
    this.setupSaveDraft();
    this.setupTooltips();
    this.setupKeyboardShortcuts();
    this.updateChecklist();
    this.loadDraft();
    this.checkProfileCV();
};

ApplyJob.prototype.setupFormValidation = function() {
    var self = this;
    
    if (this.form) {
        this.form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (self.validateForm()) {
                self.showConfirmation();
            }
        });
    }
};

ApplyJob.prototype.validateForm = function() {
    var isValid = true;
    var errors = [];
    
    // Validate message
    var message = this.messageInput ? this.messageInput.value.trim() : '';
    if (!message || message.length < 50) {
        errors.push('Cover letter must be at least 50 characters');
        isValid = false;
    } else if (message.length > 2000) {
        errors.push('Cover letter cannot exceed 2000 characters');
        isValid = false;
    }
    
    // Validate file
    if (!this.cvInput || !this.cvInput.files || this.cvInput.files.length === 0) {
        // Check if using profile CV
        var useProfileCV = document.getElementById('useProfileCV');
        if (!useProfileCV || !useProfileCV.checked) {
            errors.push('Please upload your CV or select to use profile CV');
            isValid = false;
        }
    } else {
        var file = this.cvInput.files[0];
        var validTypes = ['application/pdf', 'application/msword', 
                         'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
        var maxSize = 5 * 1024 * 1024; // 5MB
        
        if (validTypes.indexOf(file.type) === -1) {
            errors.push('File must be PDF, DOC, or DOCX format');
            isValid = false;
        }
        
        if (file.size > maxSize) {
            errors.push('File size must be less than 5MB');
            isValid = false;
        }
    }
    
    // Show errors
    if (errors.length > 0) {
        this.showErrors(errors);
    }
    
    return isValid;
};

ApplyJob.prototype.showErrors = function(errors) {
    var toastContainer = document.getElementById('toastContainer');
    
    errors.forEach(function(error) {
        var toast = document.createElement('div');
        toast.className = 'toast error';
        toast.innerHTML = `
            <div class="toast-icon">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <div class="toast-content">
                <p>${error}</p>
            </div>
            <button class="toast-close">
                <i class="fas fa-times"></i>
            </button>
        `;
        
        toastContainer.appendChild(toast);
        
        // Auto remove after 5 seconds
        setTimeout(function() {
            toast.remove();
        }, 5000);
        
        // Close button functionality
        toast.querySelector('.toast-close').addEventListener('click', function() {
            toast.remove();
        });
    });
};

ApplyJob.prototype.setupMessageInput = function() {
    var self = this;
    
    if (this.messageInput) {
        // Character counter
        this.messageInput.addEventListener('input', function() {
            var length = this.value.length;
            self.charCount.textContent = length + '/2000 characters';
            self.charCount.style.color = length > 1800 ? '#ef4444' : '#6b7280';
            
            // Update checklist
            var checkMessage = document.getElementById('checkMessage');
            if (length >= 50) {
                checkMessage.classList.add('complete');
            } else {
                checkMessage.classList.remove('complete');
            }
        });
        
        // Clear message button
        var clearMessageBtn = document.getElementById('clearMessage');
        if (clearMessageBtn) {
            clearMessageBtn.addEventListener('click', function() {
                self.messageInput.value = '';
                self.messageInput.dispatchEvent(new Event('input'));
                self.showToast('Message cleared', 'info');
            });
        }
        
        // Format message button
        var formatMessageBtn = document.getElementById('formatMessage');
        if (formatMessageBtn) {
            formatMessageBtn.addEventListener('click', function() {
                self.formatMessage();
            });
        }
    }
};

ApplyJob.prototype.formatMessage = function() {
    var message = this.messageInput.value;
    
    // Add basic formatting
    var formatted = message
        .replace(/\n\s*\n\s*\n/g, '\n\n') // Remove multiple empty lines
        .replace(/^/gm, function(match) { // Add proper paragraph spacing
            return match.trim() === '' ? match : '  ' + match;
        });
    
    // Capitalize first letter of each sentence
    formatted = formatted.replace(/(^\s*\w|[\.\!\?]\s+\w)/g, function(c) {
        return c.toUpperCase();
    });
    
    this.messageInput.value = formatted;
    this.messageInput.dispatchEvent(new Event('input'));
    this.showToast('Message formatted', 'success');
};

ApplyJob.prototype.setupFileUpload = function() {
    var self = this;
    
    if (this.uploadArea && this.cvInput) {
        // Click to upload
        this.uploadArea.addEventListener('click', function(e) {
            if (e.target !== self.cvInput) {
                self.cvInput.click();
            }
        });
        
        // File selection
        this.cvInput.addEventListener('change', function(e) {
            if (this.files && this.files[0]) {
                self.handleFileSelection(this.files[0]);
            }
        });
        
        // Drag and drop
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(function(eventName) {
            self.uploadArea.addEventListener(eventName, function(e) {
                e.preventDefault();
                e.stopPropagation();
            });
        });
        
        ['dragenter', 'dragover'].forEach(function(eventName) {
            self.uploadArea.addEventListener(eventName, function() {
                self.uploadArea.classList.add('drag-over');
            });
        });
        
        ['dragleave', 'drop'].forEach(function(eventName) {
            self.uploadArea.addEventListener(eventName, function() {
                self.uploadArea.classList.remove('drag-over');
            });
        });
        
        // Handle dropped files
        this.uploadArea.addEventListener('drop', function(e) {
            var files = e.dataTransfer.files;
            if (files && files[0]) {
                self.handleFileSelection(files[0]);
                self.cvInput.files = files;
            }
        });
        
        // Remove file button
        var removeFileBtn = document.getElementById('removeFile');
        if (removeFileBtn) {
            removeFileBtn.addEventListener('click', function() {
                self.removeFile();
            });
        }
        
        // Use profile CV checkbox
        var useProfileCV = document.getElementById('useProfileCV');
        if (useProfileCV) {
            useProfileCV.addEventListener('change', function() {
                if (this.checked) {
                    self.cvInput.disabled = true;
                    self.uploadArea.style.opacity = '0.5';
                    self.uploadArea.style.pointerEvents = 'none';
                    
                    // Update checklist
                    var checkCV = document.getElementById('checkCV');
                    checkCV.classList.add('complete');
                    
                    self.showToast('Using profile CV', 'info');
                } else {
                    self.cvInput.disabled = false;
                    self.uploadArea.style.opacity = '1';
                    self.uploadArea.style.pointerEvents = 'auto';
                    
                    // Update checklist
                    var checkCV = document.getElementById('checkCV');
                    if (!self.fileUploaded) {
                        checkCV.classList.remove('complete');
                    }
                }
            });
        }
    }
};

ApplyJob.prototype.handleFileSelection = function(file) {
    var self = this;
    
    // Validate file type
    var validTypes = ['application/pdf', 'application/msword', 
                     'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
    
    if (validTypes.indexOf(file.type) === -1) {
        this.showToast('Invalid file type. Please upload PDF, DOC, or DOCX.', 'error');
        return;
    }
    
    // Validate file size (5MB)
    if (file.size > 5 * 1024 * 1024) {
        this.showToast('File size exceeds 5MB limit.', 'error');
        return;
    }
    
    // Update file info
    this.currentFileName = file.name;
    this.currentFileSize = this.formatFileSize(file.size);
    this.fileUploaded = true;
    
    // Update UI
    this.showFilePreview();
    this.simulateUploadProgress();
    
    // Update checklist
    var checkCV = document.getElementById('checkCV');
    checkCV.classList.add('complete');
    
    this.showToast('File selected: ' + file.name, 'success');
};

ApplyJob.prototype.formatFileSize = function(bytes) {
    if (bytes === 0) return '0 Bytes';
    var k = 1024;
    var sizes = ['Bytes', 'KB', 'MB', 'GB'];
    var i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

ApplyJob.prototype.showFilePreview = function() {
    if (this.filePreview) {
        var fileName = document.getElementById('fileName');
        var fileSize = document.getElementById('fileSize');
        var fileIcon = this.filePreview.querySelector('.file-icon');
        
        if (fileName) fileName.textContent = this.currentFileName;
        if (fileSize) fileSize.textContent = this.currentFileSize;
        
        // Set appropriate icon based on file type
        if (this.currentFileName.toLowerCase().endsWith('.pdf')) {
            fileIcon.className = 'fas fa-file-pdf file-icon';
            fileIcon.style.color = '#ef4444';
        } else if (this.currentFileName.toLowerCase().endsWith('.doc') || 
                   this.currentFileName.toLowerCase().endsWith('.docx')) {
            fileIcon.className = 'fas fa-file-word file-icon';
            fileIcon.style.color = '#2563eb';
        }
        
        this.filePreview.style.display = 'block';
        this.uploadArea.style.display = 'none';
    }
};

ApplyJob.prototype.simulateUploadProgress = function() {
    var progressFill = document.querySelector('.progress-fill');
    var progressText = document.getElementById('progressText');
    var self = this;
    
    if (progressFill && progressText) {
        var width = 0;
        var interval = setInterval(function() {
            if (width >= 100) {
                clearInterval(interval);
                progressText.textContent = 'Upload complete!';
                self.showToast('CV uploaded successfully', 'success');
            } else {
                width += 10;
                progressFill.style.width = width + '%';
                progressText.textContent = 'Uploading... ' + width + '%';
            }
        }, 100);
    }
};

ApplyJob.prototype.removeFile = function() {
    if (this.cvInput) {
        this.cvInput.value = '';
        this.fileUploaded = false;
        this.currentFileName = '';
        this.currentFileSize = '';
        
        // Update UI
        if (this.filePreview) {
            this.filePreview.style.display = 'none';
        }
        if (this.uploadArea) {
            this.uploadArea.style.display = 'block';
        }
        
        // Update checklist
        var checkCV = document.getElementById('checkCV');
        var useProfileCV = document.getElementById('useProfileCV');
        
        if (!useProfileCV || !useProfileCV.checked) {
            checkCV.classList.remove('complete');
        }
        
        this.showToast('File removed', 'info');
    }
};

ApplyJob.prototype.setupChecklist = function() {
    var self = this;
    
    // Mark job details as reviewed after 3 seconds
    setTimeout(function() {
        var checkDetails = document.getElementById('checkDetails');
        if (checkDetails) {
            checkDetails.classList.add('complete');
            self.updateChecklist();
        }
    }, 3000);
};

ApplyJob.prototype.updateChecklist = function() {
    var checklistItems = document.querySelectorAll('.checklist-item');
    var allComplete = true;
    
    checklistItems.forEach(function(item) {
        if (!item.classList.contains('complete')) {
            allComplete = false;
        }
    });
    
    if (allComplete) {
        this.showToast('All requirements completed! Ready to submit.', 'success');
    }
};

ApplyJob.prototype.setupConfirmationModal = function() {
    var self = this;
    var confirmationModal = document.getElementById('confirmationModal');
    var confirmSubmitBtn = document.getElementById('confirmSubmit');
    var confirmCancelBtn = document.getElementById('confirmCancel');
    
    if (confirmationModal && confirmSubmitBtn && confirmCancelBtn) {
        confirmSubmitBtn.addEventListener('click', function() {
            self.submitForm();
        });
        
        confirmCancelBtn.addEventListener('click', function() {
            self.hideConfirmation();
        });
        
        // Close modal on background click
        confirmationModal.addEventListener('click', function(e) {
            if (e.target === confirmationModal) {
                self.hideConfirmation();
            }
        });
    }
};

ApplyJob.prototype.showConfirmation = function() {
    var confirmationModal = document.getElementById('confirmationModal');
    if (confirmationModal) {
        confirmationModal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
};

ApplyJob.prototype.hideConfirmation = function() {
    var confirmationModal = document.getElementById('confirmationModal');
    if (confirmationModal) {
        confirmationModal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
};

ApplyJob.prototype.submitForm = function() {
    var self = this;
    
    if (this.isSubmitting) return;
    
    this.isSubmitting = true;
    this.hideConfirmation();
    
    // Show loading overlay
    var loadingOverlay = document.getElementById('loadingOverlay');
    if (loadingOverlay) {
        loadingOverlay.style.display = 'flex';
    }
    
    // Disable submit button
    if (this.submitBtn) {
        this.submitBtn.disabled = true;
        this.submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
    }
    
    // Simulate API call delay
    setTimeout(function() {
        // In real implementation, this would be the actual form submission
        // For now, we'll submit the form
        if (self.form) {
            self.form.submit();
        }
        
        // Reset button state (in case submission fails)
        self.isSubmitting = false;
        if (self.submitBtn) {
            self.submitBtn.disabled = false;
            self.submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Submit Application';
        }
        
        // Hide loading overlay
        if (loadingOverlay) {
            loadingOverlay.style.display = 'none';
        }
    }, 2000);
};

ApplyJob.prototype.setupSaveDraft = function() {
    var self = this;
    var saveDraftBtn = document.getElementById('saveDraftBtn');
    var saveDraftModal = document.getElementById('saveDraftModal');
    var draftModalClose = document.getElementById('draftModalClose');
    var draftCancel = document.getElementById('draftCancel');
    var draftSave = document.getElementById('draftSave');
    
    if (saveDraftBtn && saveDraftModal) {
        saveDraftBtn.addEventListener('click', function() {
            self.showSaveDraftModal();
        });
        
        if (draftModalClose) {
            draftModalClose.addEventListener('click', function() {
                self.hideSaveDraftModal();
            });
        }
        
        if (draftCancel) {
            draftCancel.addEventListener('click', function() {
                self.hideSaveDraftModal();
            });
        }
        
        if (draftSave) {
            draftSave.addEventListener('click', function() {
                self.saveDraft();
            });
        }
        
        // Close modal on background click
        saveDraftModal.addEventListener('click', function(e) {
            if (e.target === saveDraftModal) {
                self.hideSaveDraftModal();
            }
        });
    }
};

ApplyJob.prototype.showSaveDraftModal = function() {
    var saveDraftModal = document.getElementById('saveDraftModal');
    if (saveDraftModal) {
        saveDraftModal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
};

ApplyJob.prototype.hideSaveDraftModal = function() {
    var saveDraftModal = document.getElementById('saveDraftModal');
    if (saveDraftModal) {
        saveDraftModal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
};

ApplyJob.prototype.saveDraft = function() {
    var draftName = document.getElementById('draftName').value;
    var draftReminder = document.getElementById('draftReminder').value;
    
    var draft = {
        name: draftName,
        reminder: draftReminder,
        message: this.messageInput ? this.messageInput.value : '',
        timestamp: new Date().toISOString(),
        jobId: this.getJobIdFromForm()
    };
    
    // Save to localStorage
    var drafts = JSON.parse(localStorage.getItem('jobApplicationDrafts') || '[]');
    drafts.push(draft);
    localStorage.setItem('jobApplicationDrafts', JSON.stringify(drafts));
    
    this.hideSaveDraftModal();
    this.showToast('Draft saved successfully!', 'success');
    
    // Set reminder if selected
    if (draftReminder) {
        this.setReminder(draft);
    }
};

ApplyJob.prototype.getJobIdFromForm = function() {
    var jobIdInput = this.form ? this.form.querySelector('input[name="job_id"]') : null;
    return jobIdInput ? jobIdInput.value : null;
};

ApplyJob.prototype.setReminder = function(draft) {
    var reminderDays = parseInt(draft.reminder);
    var reminderDate = new Date();
    reminderDate.setDate(reminderDate.getDate() + reminderDays);
    
    var reminder = {
        id: 'draft_reminder_' + Date.now(),
        draftName: draft.name,
        reminderDate: reminderDate.toISOString(),
        jobId: draft.jobId
    };
    
    var reminders = JSON.parse(localStorage.getItem('applicationReminders') || '[]');
    reminders.push(reminder);
    localStorage.setItem('applicationReminders', JSON.stringify(reminders));
    
    this.showToast('Reminder set for ' + reminderDays + ' day(s) from now', 'info');
};

ApplyJob.prototype.loadDraft = function() {
    var drafts = JSON.parse(localStorage.getItem('jobApplicationDrafts') || '[]');
    if (drafts.length > 0) {
        // Check if there's a draft for this job
        var currentJobId = this.getJobIdFromForm();
        var jobDraft = drafts.find(function(draft) {
            return draft.jobId === currentJobId;
        });
        
        if (jobDraft && this.messageInput) {
            this.messageInput.value = jobDraft.message;
            this.messageInput.dispatchEvent(new Event('input'));
            this.showToast('Loaded previous draft for this job', 'info');
        }
    }
};

ApplyJob.prototype.checkProfileCV = function() {
    // Simulate checking if user has a profile CV
    // In a real application, this would be an API call
    setTimeout(function() {
        var cvLastUpdated = document.getElementById('cvLastUpdated');
        if (cvLastUpdated) {
            // Check localStorage for CV info
            var cvInfo = localStorage.getItem('profileCVInfo');
            if (cvInfo) {
                cvInfo = JSON.parse(cvInfo);
                cvLastUpdated.textContent = new Date(cvInfo.lastUpdated).toLocaleDateString();
            } else {
                cvLastUpdated.textContent = 'Never';
            }
        }
    }, 1000);
};

ApplyJob.prototype.setupTooltips = function() {
    var tooltipElements = document.querySelectorAll('[data-tooltip]');
    
    tooltipElements.forEach(function(element) {
        var tooltipText = element.getAttribute('data-tooltip');
        
        element.addEventListener('mouseenter', function(e) {
            var tooltip = document.createElement('div');
            tooltip.className = 'tooltip';
            tooltip.textContent = tooltipText;
            tooltip.style.position = 'absolute';
            tooltip.style.background = 'rgba(0, 0, 0, 0.8)';
            tooltip.style.color = 'white';
            tooltip.style.padding = '5px 10px';
            tooltip.style.borderRadius = '4px';
            tooltip.style.fontSize = '12px';
            tooltip.style.zIndex = '1000';
            tooltip.style.whiteSpace = 'nowrap';
            
            var rect = element.getBoundingClientRect();
            tooltip.style.top = (rect.top - 30) + 'px';
            tooltip.style.left = (rect.left + rect.width / 2) + 'px';
            tooltip.style.transform = 'translateX(-50%)';
            
            tooltip.setAttribute('id', 'currentTooltip');
            document.body.appendChild(tooltip);
        });
        
        element.addEventListener('mouseleave', function() {
            var tooltip = document.getElementById('currentTooltip');
            if (tooltip) {
                tooltip.remove();
            }
        });
    });
};

ApplyJob.prototype.setupKeyboardShortcuts = function() {
    var self = this;
    
    document.addEventListener('keydown', function(e) {
        // Ctrl+S to save draft
        if ((e.ctrlKey || e.metaKey) && e.key === 's') {
            e.preventDefault();
            self.showSaveDraftModal();
        }
        
        // Escape to close modals
        if (e.key === 'Escape') {
            self.hideConfirmation();
            self.hideSaveDraftModal();
        }
        
        // Ctrl+Enter to submit
        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
            e.preventDefault();
            if (self.validateForm()) {
                self.showConfirmation();
            }
        }
    });
};

ApplyJob.prototype.showToast = function(message, type) {
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

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    new ApplyJob();
});

// Add CSS for toast notifications (dynamically added if not in main CSS)
if (!document.querySelector('#toastStyles')) {
    var style = document.createElement('style');
    style.id = 'toastStyles';
    style.textContent = `
        .toast-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .toast {
            background: white;
            border-radius: 8px;
            padding: 15px 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
        
        .toast.success {
            border-left-color: #10b981;
        }
        
        .toast.error {
            border-left-color: #ef4444;
        }
        
        .toast.info {
            border-left-color: #3b82f6;
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
        
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 99999;
        }
        
        .loading-spinner {
            background: white;
            padding: 40px;
            border-radius: 12px;
            text-align: center;
        }
        
        .loading-spinner i {
            font-size: 3rem;
            color: #3b82f6;
            margin-bottom: 20px;
        }
        
        .confirmation-modal {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 99999;
        }
        
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 99999;
        }
        
        .modal-content {
            background: white;
            border-radius: 12px;
            padding: 30px;
            min-width: 400px;
            max-width: 500px;
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    `;
    document.head.appendChild(style);
}