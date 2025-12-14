/**
 * Add CV Template Management
 * Enhanced with modern features and animations
 * @class AddCVTemplate
 * @version 1.0.0
 */

/* global document, window, localStorage, console */

/**
 * Main AddCVTemplate class
 */
class AddCVTemplate {
    
    /**
     * Creates a new AddCVTemplate instance
     * @constructor
     */
    constructor() {
        /** @type {string} Current theme */
        this.currentTheme = localStorage.getItem('adminTheme') || 'light';
        
        /** @type {File|null} Selected file */
        this.selectedFile = null;
        
        /** @type {number} Maximum file size in bytes (10MB) */
        this.maxFileSize = 10 * 1024 * 1024;
        
        /** @type {Array<string>} Allowed file extensions */
        this.allowedExtensions = ['.pdf', '.doc', '.docx', '.html', '.txt', '.rtf'];
        
        /** @type {boolean} Form validation state */
        this.isFormValid = false;
        
        this.init();
    }
    
    /**
     * Initialize the application
     * @method init
     * @returns {void}
     */
    init() {
        // Initialize when DOM is loaded
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setup());
        } else {
            this.setup();
        }
    }
    
    /**
     * Set up all components
     * @method setup
     * @returns {void}
     */
    setup() {
        this.setupTheme();
        this.setupFormValidation();
        this.setupFileUpload();
        this.setupCharacterCounter();
        this.setupAnimations();
        this.setupLoading();
        this.setupNotifications();
        this.setupPreviewModal();
    }
    
    /**
     * Set up theme toggle functionality
     * @method setupTheme
     * @returns {void}
     */
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
    
    /**
     * Toggle between light and dark themes
     * @method toggleTheme
     * @returns {void}
     */
    toggleTheme() {
        const body = document.body;
        
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
    
    /**
     * Update theme button text and icon
     * @method updateThemeButton
     * @param {string} targetTheme - Target theme
     * @returns {void}
     */
    updateThemeButton(targetTheme) {
        const themeToggle = document.getElementById('themeToggle');
        if (!themeToggle) {
            return;
        }
        
        if (targetTheme === 'light') {
            themeToggle.innerHTML = '<i class="fas fa-sun"></i><span>Light Mode</span>';
        } else {
            themeToggle.innerHTML = '<i class="fas fa-moon"></i><span>Dark Mode</span>';
        }
    }
    
    /**
     * Set up form validation
     * @method setupFormValidation
     * @returns {void}
     */
    setupFormValidation() {
        const form = document.getElementById('uploadForm');
        const submitBtn = document.getElementById('submitBtn');
        
        if (!form || !submitBtn) {
            return;
        }
        
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            
            // Validate form
            if (!this.validateForm()) {
                this.showToast('Please fix the errors in the form', 'error');
                return;
            }
            
            // Show loading and submit
            this.showLoading();
            
            // Simulate upload process
            setTimeout(() => {
                this.hideLoading();
                form.submit();
            }, 1500);
        });
        
        // Real-time validation
        const nameInput = document.getElementById('templateName');
        const fileInput = document.getElementById('templateFile');
        
        if (nameInput) {
            nameInput.addEventListener('input', () => {
                this.validateName();
            });
        }
        
        if (fileInput) {
            fileInput.addEventListener('change', () => {
                this.handleFileSelect(fileInput.files[0]);
            });
        }
    }
    
    /**
     * Validate the entire form
     * @method validateForm
     * @returns {boolean} True if form is valid
     */
    validateForm() {
        const nameValid = this.validateName();
        const fileValid = this.validateFile();
        
        this.isFormValid = nameValid && fileValid;
        
        // Update submit button state
        const submitBtn = document.getElementById('submitBtn');
        if (submitBtn) {
            submitBtn.disabled = !this.isFormValid;
        }
        
        return this.isFormValid;
    }
    
    /**
     * Validate template name
     * @method validateName
     * @returns {boolean} True if name is valid
     */
    validateName() {
        const nameInput = document.getElementById('templateName');
        const name = nameInput ? nameInput.value.trim() : '';
        
        if (!name) {
            this.showFieldError(nameInput, 'Template name is required');
            return false;
        }
        
        if (name.length > 100) {
            this.showFieldError(nameInput, 'Name must be less than 100 characters');
            return false;
        }
        
        this.clearFieldError(nameInput);
        return true;
    }
    
    /**
     * Validate selected file
     * @method validateFile
     * @returns {boolean} True if file is valid
     */
    validateFile() {
        if (!this.selectedFile) {
            this.showToast('Please select a file to upload', 'error');
            return false;
        }
        
        // Check file extension
        const fileExt = this.getFileExtension(this.selectedFile.name);
        if (!this.allowedExtensions.includes(fileExt.toLowerCase())) {
            this.showToast(`File type ${fileExt} is not allowed. Please upload: ${this.allowedExtensions.join(', ')}`, 'error');
            return false;
        }
        
        // Check file size
        if (this.selectedFile.size > this.maxFileSize) {
            this.showToast(`File size (${this.formatFileSize(this.selectedFile.size)}) exceeds maximum limit of 10MB`, 'error');
            return false;
        }
        
        return true;
    }
    
    /**
     * Show field error
     * @method showFieldError
     * @param {HTMLElement} input - Input element
     * @param {string} message - Error message
     * @returns {void}
     */
    showFieldError(input, message) {
        if (!input) return;
        
        input.classList.add('error');
        
        // Remove existing error message
        const existingError = input.parentNode.querySelector('.error-message');
        if (existingError) {
            existingError.remove();
        }
        
        // Add new error message
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-message';
        errorDiv.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
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
    
    /**
     * Clear field error
     * @method clearFieldError
     * @param {HTMLElement} input - Input element
     * @returns {void}
     */
    clearFieldError(input) {
        if (!input) return;
        
        input.classList.remove('error');
        input.style.animation = '';
        
        // Remove error message
        const errorDiv = input.parentNode.querySelector('.error-message');
        if (errorDiv) {
            errorDiv.remove();
        }
    }
    
    /**
     * Set up file upload functionality
     * @method setupFileUpload
     * @returns {void}
     */
    setupFileUpload() {
        const fileInput = document.getElementById('templateFile');
        const uploadArea = document.getElementById('fileUploadArea');
        const chooseBtn = document.querySelector('.btn-choose');
        
        if (!fileInput || !uploadArea || !chooseBtn) {
            return;
        }
        
        // Click on choose button triggers file input
        chooseBtn.addEventListener('click', (e) => {
            e.preventDefault();
            fileInput.click();
        });
        
        // Drag and drop functionality
        uploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadArea.classList.add('drag-over');
        });
        
        uploadArea.addEventListener('dragleave', () => {
            uploadArea.classList.remove('drag-over');
        });
        
        uploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadArea.classList.remove('drag-over');
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                this.handleFileSelect(files[0]);
            }
        });
        
        // Click on upload area triggers file input
        uploadArea.addEventListener('click', (e) => {
            if (e.target === uploadArea || e.target.classList.contains('upload-icon') || 
                e.target.classList.contains('upload-subtitle')) {
                fileInput.click();
            }
        });
    }
    
    /**
     * Handle file selection
     * @method handleFileSelect
     * @param {File} file - Selected file
     * @returns {void}
     */
    handleFileSelect(file) {
        if (!file) {
            return;
        }
        
        // Validate file
        const fileExt = this.getFileExtension(file.name);
        if (!this.allowedExtensions.includes(fileExt.toLowerCase())) {
            this.showToast(`File type ${fileExt} is not allowed`, 'error');
            return;
        }
        
        if (file.size > this.maxFileSize) {
            this.showToast(`File size (${this.formatFileSize(file.size)}) exceeds maximum limit of 10MB`, 'error');
            return;
        }
        
        this.selectedFile = file;
        this.displayFilePreview(file);
        this.validateForm();
    }
    
    /**
     * Display file preview
     * @method displayFilePreview
     * @param {File} file - File to preview
     * @returns {void}
     */
    displayFilePreview(file) {
        const filePreview = document.getElementById('filePreview');
        if (!filePreview) {
            return;
        }
        
        const fileExt = this.getFileExtension(file.name);
        const fileType = this.getFileTypeClass(fileExt);
        const fileSize = this.formatFileSize(file.size);
        
        filePreview.innerHTML = `
            <div class="preview-card">
                <div class="preview-icon ${fileType}">
                    <i class="fas ${this.getFileIcon(fileExt)}"></i>
                </div>
                <div class="preview-content">
                    <h5>${this.escapeHtml(file.name)}</h5>
                    <div class="file-info">
                        <span><i class="fas fa-file"></i> ${fileExt.toUpperCase()}</span>
                        <span><i class="fas fa-weight"></i> ${fileSize}</span>
                        <span><i class="fas fa-calendar"></i> ${new Date(file.lastModified).toLocaleDateString()}</span>
                    </div>
                </div>
                <div class="preview-actions">
                    <button type="button" class="btn-preview" data-action="preview">
                        <i class="fas fa-eye"></i> Preview
                    </button>
                    <button type="button" class="btn-danger" data-action="remove">
                        <i class="fas fa-trash"></i> Remove
                    </button>
                </div>
            </div>
        `;
        
        filePreview.classList.add('active');
        
        // Add event listeners to preview buttons
        const previewBtn = filePreview.querySelector('[data-action="preview"]');
        const removeBtn = filePreview.querySelector('[data-action="remove"]');
        
        if (previewBtn) {
            previewBtn.addEventListener('click', () => {
                this.previewFile(file);
            });
        }
        
        if (removeBtn) {
            removeBtn.addEventListener('click', () => {
                this.removeFile();
            });
        }
    }
    
    /**
     * Remove selected file
     * @method removeFile
     * @returns {void}
     */
    removeFile() {
        const fileInput = document.getElementById('templateFile');
        const filePreview = document.getElementById('filePreview');
        
        if (fileInput) {
            fileInput.value = '';
        }
        
        if (filePreview) {
            filePreview.classList.remove('active');
            filePreview.innerHTML = '';
        }
        
        this.selectedFile = null;
        this.validateForm();
        
        this.showToast('File removed', 'info');
    }
    
    /**
     * Preview file content
     * @method previewFile
     * @param {File} file - File to preview
     * @returns {void}
     */
    previewFile(file) {
        const modal = document.getElementById('previewModal');
        const previewBody = document.getElementById('previewBody');
        
        if (!modal || !previewBody) {
            return;
        }
        
        const fileExt = this.getFileExtension(file.name);
        const fileName = this.escapeHtml(file.name);
        
        // Show loading in preview
        previewBody.innerHTML = `
            <div class="loading-preview">
                <i class="fas fa-spinner fa-spin"></i>
                <p>Loading preview...</p>
            </div>
        `;
        
        modal.classList.add('active');
        
        // Read and display file content based on type
        const reader = new FileReader();
        
        if (fileExt.toLowerCase() === '.pdf') {
            // For PDF, show download link
            setTimeout(() => {
                previewBody.innerHTML = `
                    <div class="pdf-preview">
                        <div class="preview-icon large">
                            <i class="fas fa-file-pdf"></i>
                        </div>
                        <h4>${fileName}</h4>
                        <p>PDF files cannot be previewed directly in the browser.</p>
                        <p>Click the download button below to view the file.</p>
                        <div class="preview-actions">
                            <a href="${URL.createObjectURL(file)}" download="${fileName}" class="btn btn-primary">
                                <i class="fas fa-download"></i> Download PDF
                            </a>
                        </div>
                    </div>
                `;
            }, 500);
        } else if (fileExt.toLowerCase() === '.html') {
            // For HTML, show iframe preview
            reader.onload = (e) => {
                previewBody.innerHTML = `
                    <div class="html-preview">
                        <h4>${fileName} - HTML Preview</h4>
                        <div class="preview-frame">
                            <iframe src="data:text/html;charset=utf-8,${encodeURIComponent(e.target.result)}" 
                                    title="HTML Preview" 
                                    sandbox="allow-scripts">
                            </iframe>
                        </div>
                        <div class="preview-warning">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>Note: Some scripts and external resources may be blocked for security.</span>
                        </div>
                    </div>
                `;
            };
            reader.readAsText(file);
        } else if (fileExt.toLowerCase() === '.txt') {
            // For text files, show content
            reader.onload = (e) => {
                const content = this.escapeHtml(e.target.result);
                previewBody.innerHTML = `
                    <div class="text-preview">
                        <h4>${fileName} - Text Preview</h4>
                        <pre class="text-content">${content}</pre>
                    </div>
                `;
            };
            reader.readAsText(file);
        } else {
            // For other files (doc, docx, rtf), show download link
            setTimeout(() => {
                previewBody.innerHTML = `
                    <div class="file-preview">
                        <div class="preview-icon large ${this.getFileTypeClass(fileExt)}">
                            <i class="fas ${this.getFileIcon(fileExt)}"></i>
                        </div>
                        <h4>${fileName}</h4>
                        <p>This file type (${fileExt.toUpperCase()}) cannot be previewed directly in the browser.</p>
                        <p>Click the download button below to view the file.</p>
                        <div class="preview-actions">
                            <a href="${URL.createObjectURL(file)}" download="${fileName}" class="btn btn-primary">
                                <i class="fas fa-download"></i> Download File
                            </a>
                        </div>
                    </div>
                `;
            }, 500);
        }
    }
    
    /**
     * Set up character counter for textarea
     * @method setupCharacterCounter
     * @returns {void}
     */
    setupCharacterCounter() {
        const textarea = document.getElementById('templateDescription');
        const charCount = document.getElementById('charCount');
        
        if (!textarea || !charCount) {
            return;
        }
        
        textarea.addEventListener('input', () => {
            const length = textarea.value.length;
            charCount.textContent = `${length}/500`;
            
            // Update color based on length
            if (length > 450) {
                charCount.className = 'danger';
            } else if (length > 400) {
                charCount.className = 'warning';
            } else {
                charCount.className = '';
            }
            
            // Limit to 500 characters
            if (length > 500) {
                textarea.value = textarea.value.substring(0, 500);
                charCount.textContent = '500/500';
                charCount.className = 'danger';
                this.showToast('Description limited to 500 characters', 'warning');
            }
        });
    }
    
    /**
     * Set up preview modal
     * @method setupPreviewModal
     * @returns {void}
     */
    setupPreviewModal() {
        const modal = document.getElementById('previewModal');
        const closeBtn = document.getElementById('previewClose');
        
        if (!modal || !closeBtn) {
            return;
        }
        
        // Close modal on close button click
        closeBtn.addEventListener('click', () => {
            modal.classList.remove('active');
        });
        
        // Close modal on backdrop click
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.classList.remove('active');
            }
        });
        
        // Close modal on Escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && modal.classList.contains('active')) {
                modal.classList.remove('active');
            }
        });
    }
    
    /**
     * Set up animations
     * @method setupAnimations
     * @returns {void}
     */
    setupAnimations() {
        // Add floating animation to page icon
        const pageIcon = document.querySelector('.page-icon');
        if (pageIcon) {
            pageIcon.style.animation = 'float 6s infinite ease-in-out';
        }
        
        // Add animations to form sections
        const formSections = document.querySelectorAll('.form-section, .features-section');
        formSections.forEach((section, index) => {
            section.style.animationDelay = `${index * 0.2}s`;
            section.classList.add('fade-in');
        });
        
        // Add ripple effect to buttons
        const buttons = document.querySelectorAll('.btn:not([disabled])');
        buttons.forEach((button) => {
            button.addEventListener('click', (e) => {
                const ripple = document.createElement('span');
                const rect = button.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.cssText = `
                    position: absolute;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, 0.7);
                    transform: scale(0);
                    animation: ripple 0.6s linear;
                    width: ${size}px;
                    height: ${size}px;
                    left: ${x}px;
                    top: ${y}px;
                    pointer-events: none;
                `;
                
                button.appendChild(ripple);
                setTimeout(() => {
                    if (ripple.parentNode) {
                        ripple.remove();
                    }
                }, 600);
            });
        });
        
        // Add custom animations CSS
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
            
            .error {
                border-color: var(--danger) !important;
                background: rgba(239, 68, 68, 0.05) !important;
            }
            
            .loading-preview {
                text-align: center;
                padding: 60px 20px;
                color: var(--text-secondary);
            }
            
            .loading-preview i {
                font-size: 2.5rem;
                margin-bottom: 20px;
                color: var(--primary);
            }
            
            .preview-icon.large {
                width: 100px;
                height: 100px;
                font-size: 3rem;
                margin: 0 auto 20px;
            }
            
            .preview-frame {
                width: 100%;
                height: 400px;
                border: 1px solid var(--border-light);
                border-radius: var(--radius-lg);
                overflow: hidden;
                margin: 20px 0;
            }
            
            .preview-frame iframe {
                width: 100%;
                height: 100%;
                border: none;
            }
            
            .preview-warning {
                background: rgba(245, 158, 11, 0.1);
                border: 1px solid rgba(245, 158, 11, 0.3);
                border-radius: var(--radius-md);
                padding: 12px 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                color: var(--warning);
                margin-top: 20px;
            }
            
            .text-preview pre {
                background: var(--bg-secondary);
                border: 1px solid var(--border-light);
                border-radius: var(--radius-lg);
                padding: 20px;
                font-family: 'Courier New', monospace;
                white-space: pre-wrap;
                word-wrap: break-word;
                max-height: 400px;
                overflow-y: auto;
                margin-top: 20px;
            }
            
            .file-preview, .pdf-preview, .html-preview {
                text-align: center;
            }
        `;
        document.head.appendChild(style);
    }
    
    /**
     * Set up loading overlay
     * @method setupLoading
     * @returns {void}
     */
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
                    <p>Uploading Template...</p>
                </div>
            `;
            document.body.appendChild(overlay);
        }
    }
    
    /**
     * Show loading overlay
     * @method showLoading
     * @returns {void}
     */
    showLoading() {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }
    }
    
    /**
     * Hide loading overlay
     * @method hideLoading
     * @returns {void}
     */
    hideLoading() {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.style.display = 'none';
            document.body.style.overflow = '';
        }
    }
    
    /**
     * Set up notifications
     * @method setupNotifications
     * @returns {void}
     */
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
    
    /**
     * Show toast notification
     * @method showToast
     * @param {string} message - Message to display
     * @param {string} type - Toast type (success, error, warning, info)
     * @returns {void}
     */
    showToast(message, type = 'info') {
        const container = document.getElementById('toastContainer');
        if (!container) {
            return;
        }
        
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        
        // Set icon based on type
        let icon = 'info-circle';
        if (type === 'success') {
            icon = 'check-circle';
        }
        if (type === 'error') {
            icon = 'exclamation-circle';
        }
        if (type === 'warning') {
            icon = 'exclamation-triangle';
        }
        
        toast.innerHTML = `
            <i class="fas fa-${icon}"></i>
            <span>${this.escapeHtml(message)}</span>
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
    
    /**
     * Get file extension
     * @method getFileExtension
     * @param {string} filename - File name
     * @returns {string} File extension
     */
    getFileExtension(filename) {
        return '.' + filename.split('.').pop().toLowerCase();
    }
    
    /**
     * Get file type class
     * @method getFileTypeClass
     * @param {string} extension - File extension
     * @returns {string} CSS class for file type
     */
    getFileTypeClass(extension) {
        switch (extension.toLowerCase()) {
            case '.pdf': return 'pdf';
            case '.doc':
            case '.docx': return 'word';
            case '.html': return 'html';
            default: return 'other';
        }
    }
    
    /**
     * Get file icon
     * @method getFileIcon
     * @param {string} extension - File extension
     * @returns {string} Icon class
     */
    getFileIcon(extension) {
        switch (extension.toLowerCase()) {
            case '.pdf': return 'fa-file-pdf';
            case '.doc':
            case '.docx': return 'fa-file-word';
            case '.html': return 'fa-file-code';
            case '.txt': return 'fa-file-alt';
            case '.rtf': return 'fa-file';
            default: return 'fa-file';
        }
    }
    
    /**
     * Format file size
     * @method formatFileSize
     * @param {number} bytes - File size in bytes
     * @returns {string} Formatted file size
     */
    formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }
    
    /**
     * Escape HTML special characters
     * @method escapeHtml
     * @param {string} text - Text to escape
     * @returns {string} Escaped text
     */
    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.addCVTemplateApp = new AddCVTemplate();
});

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { AddCVTemplate };
}