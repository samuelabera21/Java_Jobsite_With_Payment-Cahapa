/**
 * CV Builder Management
 * Enhanced with multi-step form, preview, and interactive features
 * @class CVBuilder
 * @version 1.0.0
 */

/* global document, window, localStorage, console */

function CVBuilder() {
    this.form = document.getElementById('cvBuilderForm');
    this.currentStep = 1;
    this.totalSteps = 5;
    this.files = [];
    this.skills = [];
    
    // Form elements
    this.headlineInput = document.getElementById('headlineInput');
    this.aboutInput = document.getElementById('aboutInput');
    this.educationInput = document.getElementById('educationInput');
    this.experienceInput = document.getElementById('experienceInput');
    this.skillsInput = document.getElementById('skillsInput');
    this.attachmentsInput = document.getElementById('attachmentsInput');
    
    // Navigation elements
    this.prevStepBtn = document.getElementById('prevStep');
    this.nextStepBtn = document.getElementById('nextStep');
    this.submitBtn = document.getElementById('submitBtn');
    this.previewBtn = document.getElementById('previewBtn');
    this.resetBtn = document.getElementById('resetBtn');
    this.cancelBtn = document.getElementById('cancelBtn');
    
    // Other elements
    this.themeToggle = document.getElementById('themeToggle');
    this.skillsPreview = document.getElementById('skillsPreview');
    this.filePreviewContainer = document.getElementById('filePreviewContainer');
    this.uploadArea = document.getElementById('uploadArea');
    
    this.init();
}

CVBuilder.prototype.init = function() {
    var self = this;
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            self.setup();
        });
    } else {
        this.setup();
    }
};

CVBuilder.prototype.setup = function() {
    this.setupThemeToggle();
    this.setupStepNavigation();
    this.setupFormValidation();
    this.setupCharacterCounters();
    this.setupTextareaTools();
    this.setupSkillsInput();
    this.setupFileUpload();
    this.setupPreview();
    this.setupReset();
    this.setupModals();
    this.setupKeyboardShortcuts();
    this.setupFadeAnimations();
    this.loadDraft();
};

CVBuilder.prototype.setupThemeToggle = function() {
    var self = this;
    
    if (this.themeToggle) {
        this.themeToggle.addEventListener('click', function() {
            self.toggleTheme();
        });
        
        // Load saved theme
        var savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'dark') {
            document.body.classList.add('dark-theme');
            var icon = this.querySelector('i');
            var text = this.querySelector('span');
            if (icon) icon.className = 'fas fa-sun';
            if (text) text.textContent = 'Light Mode';
        }
    }
};

CVBuilder.prototype.toggleTheme = function() {
    var icon = this.themeToggle.querySelector('i');
    var text = this.themeToggle.querySelector('span');
    
    if (document.body.classList.contains('dark-theme')) {
        document.body.classList.remove('dark-theme');
        if (icon) icon.className = 'fas fa-moon';
        if (text) text.textContent = 'Dark Mode';
        localStorage.setItem('theme', 'light');
        this.showToast('Switched to Light Mode', 'info');
    } else {
        document.body.classList.add('dark-theme');
        if (icon) icon.className = 'fas fa-sun';
        if (text) text.textContent = 'Light Mode';
        localStorage.setItem('theme', 'dark');
        this.showToast('Switched to Dark Mode', 'info');
    }
};

CVBuilder.prototype.setupStepNavigation = function() {
    var self = this;
    
    // Next step button
    if (this.nextStepBtn) {
        this.nextStepBtn.addEventListener('click', function() {
            if (self.validateCurrentStep()) {
                self.nextStep();
            }
        });
    }
    
    // Previous step button
    if (this.prevStepBtn) {
        this.prevStepBtn.addEventListener('click', function() {
            self.prevStep();
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

CVBuilder.prototype.validateCurrentStep = function() {
    var isValid = true;
    var errors = [];
    
    switch (this.currentStep) {
        case 1: // Basic Info
            if (!this.headlineInput || !this.headlineInput.value.trim()) {
                errors.push('Please enter a headline');
                isValid = false;
                this.headlineInput.classList.add('invalid');
            } else if (this.headlineInput.value.trim().length < 5) {
                errors.push('Headline should be at least 5 characters');
                isValid = false;
                this.headlineInput.classList.add('invalid');
            } else {
                this.headlineInput.classList.remove('invalid');
            }
            
            if (!this.aboutInput || !this.aboutInput.value.trim()) {
                errors.push('Please write about yourself');
                isValid = false;
                this.aboutInput.classList.add('invalid');
            } else if (this.aboutInput.value.trim().length < 50) {
                errors.push('About section should be at least 50 characters');
                isValid = false;
                this.aboutInput.classList.add('invalid');
            } else {
                this.aboutInput.classList.remove('invalid');
            }
            break;
            
        case 2: // Education
            if (this.educationInput && this.educationInput.value.trim()) {
                var lines = this.educationInput.value.trim().split('\n');
                var filteredLines = [];
                for (var i = 0; i < lines.length; i++) {
                    if (lines[i].trim().length > 0) {
                        filteredLines.push(lines[i]);
                    }
                }
                if (filteredLines.length === 0) {
                    this.educationInput.classList.remove('invalid');
                } else if (filteredLines.length > 0 && filteredLines[0].split(',').length < 2) {
                    errors.push('Please use format: Degree, Institution, Year');
                    isValid = false;
                    this.educationInput.classList.add('invalid');
                } else {
                    this.educationInput.classList.remove('invalid');
                }
            }
            break;
            
        case 3: // Experience
            if (this.experienceInput && this.experienceInput.value.trim()) {
                var lines = this.experienceInput.value.trim().split('\n');
                var filteredLines = [];
                for (var i = 0; i < lines.length; i++) {
                    if (lines[i].trim().length > 0) {
                        filteredLines.push(lines[i]);
                    }
                }
                if (filteredLines.length === 0) {
                    this.experienceInput.classList.remove('invalid');
                } else if (filteredLines.length > 0 && filteredLines[0].split(',').length < 2) {
                    errors.push('Please use format: Position, Company, Duration');
                    isValid = false;
                    this.experienceInput.classList.add('invalid');
                } else {
                    this.experienceInput.classList.remove('invalid');
                }
            }
            break;
            
        case 4: // Skills
            // Skills are optional, no validation needed
            break;
            
        case 5: // Attachments
            // Attachments are optional, no validation needed
            break;
    }
    
    if (errors.length > 0) {
        this.showErrors(errors);
    }
    
    return isValid;
};

CVBuilder.prototype.showErrors = function(errors) {
    var self = this;
    
    for (var i = 0; i < errors.length; i++) {
        this.showToast(errors[i], 'error');
    }
};

CVBuilder.prototype.nextStep = function() {
    if (this.currentStep < this.totalSteps) {
        // Hide current step
        var currentStepElement = document.getElementById('step' + this.currentStep);
        if (currentStepElement) {
            currentStepElement.classList.remove('active');
        }
        
        // Update current step
        this.currentStep++;
        
        // Show next step
        var nextStepElement = document.getElementById('step' + this.currentStep);
        if (nextStepElement) {
            nextStepElement.classList.add('active');
        }
        
        // Update UI
        this.updateStepUI();
        
        // Save draft
        this.saveDraft();
    }
};

CVBuilder.prototype.prevStep = function() {
    if (this.currentStep > 1) {
        // Hide current step
        var currentStepElement = document.getElementById('step' + this.currentStep);
        if (currentStepElement) {
            currentStepElement.classList.remove('active');
        }
        
        // Update current step
        this.currentStep--;
        
        // Show previous step
        var prevStepElement = document.getElementById('step' + this.currentStep);
        if (prevStepElement) {
            prevStepElement.classList.add('active');
        }
        
        // Update UI
        this.updateStepUI();
    }
};

CVBuilder.prototype.updateStepUI = function() {
    var self = this;
    
    // Update progress bar
    var progressFill = document.querySelector('.progress-fill');
    if (progressFill) {
        var progressWidth = (this.currentStep / this.totalSteps) * 100;
        progressFill.style.width = progressWidth + '%';
    }
    
    // Update step indicators
    var steps = document.querySelectorAll('.step');
    for (var i = 0; i < steps.length; i++) {
        var step = steps[i];
        var stepNumber = parseInt(step.getAttribute('data-step'));
        step.classList.remove('active', 'completed');
        
        if (stepNumber < this.currentStep) {
            step.classList.add('completed');
        } else if (stepNumber === this.currentStep) {
            step.classList.add('active');
        }
    }
    
    // Update step dots
    var dots = document.querySelectorAll('.dot');
    for (var i = 0; i < dots.length; i++) {
        dots[i].classList.remove('active');
        if (i < this.currentStep) {
            dots[i].classList.add('active');
        }
    }
    
    // Update current step number
    var currentStepNumber = document.getElementById('currentStepNumber');
    if (currentStepNumber) {
        currentStepNumber.textContent = this.currentStep;
    }
    
    // Update navigation buttons
    if (this.prevStepBtn) {
        this.prevStepBtn.disabled = this.currentStep === 1;
    }
    
    if (this.nextStepBtn && this.submitBtn) {
        if (this.currentStep === this.totalSteps) {
            this.nextStepBtn.style.display = 'none';
            this.submitBtn.style.display = 'inline-flex';
        } else {
            this.nextStepBtn.style.display = 'inline-flex';
            this.submitBtn.style.display = 'none';
        }
    }
    
    // Update step in localStorage
    localStorage.setItem('cvBuilderCurrentStep', this.currentStep);
};

CVBuilder.prototype.setupFormValidation = function() {
    var self = this;
    
    if (this.form) {
        this.form.addEventListener('submit', function(e) {
            if (!self.validateForm()) {
                e.preventDefault();
            } else {
                self.handleFormSubmission();
            }
        });
    }
};

CVBuilder.prototype.validateForm = function() {
    // Validate all required steps
    for (var i = 1; i <= 3; i++) { // Steps 1-3 are required
        this.currentStep = i;
        if (!this.validateCurrentStep()) {
            // Go to the step with error
            this.goToStep(i);
            return false;
        }
    }
    
    return true;
};

CVBuilder.prototype.goToStep = function(stepNumber) {
    // Hide all steps
    for (var i = 1; i <= this.totalSteps; i++) {
        var stepElement = document.getElementById('step' + i);
        if (stepElement) {
            stepElement.classList.remove('active');
        }
    }
    
    // Show target step
    var targetStep = document.getElementById('step' + stepNumber);
    if (targetStep) {
        targetStep.classList.add('active');
    }
    
    // Update current step
    this.currentStep = stepNumber;
    this.updateStepUI();
};

CVBuilder.prototype.handleFormSubmission = function() {
    // Clear draft from localStorage
    localStorage.removeItem('cvBuilderDraft');
    localStorage.removeItem('cvBuilderCurrentStep');
    
    // Show loading state
    if (this.submitBtn) {
        this.submitBtn.disabled = true;
        this.submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving CV...';
    }
    
    this.showToast('Saving your CV...', 'info');
};

CVBuilder.prototype.setupCharacterCounters = function() {
    var self = this;
    
    // Headline counter
    if (this.headlineInput) {
        var headlineCount = document.getElementById('headlineCount');
        this.headlineInput.addEventListener('input', function() {
            if (headlineCount) {
                headlineCount.textContent = this.value.length;
                headlineCount.style.color = this.value.length > 100 ? 'var(--danger)' : 'var(--text-primary)';
            }
        });
        // Trigger initial count
        var event = document.createEvent('Event');
        event.initEvent('input', true, true);
        this.headlineInput.dispatchEvent(event);
    }
    
    // About counter
    if (this.aboutInput) {
        var aboutCount = document.getElementById('aboutCount');
        this.aboutInput.addEventListener('input', function() {
            if (aboutCount) {
                aboutCount.textContent = this.value.length;
                aboutCount.style.color = this.value.length > 2000 ? 'var(--danger)' : 'var(--text-primary)';
            }
        });
        // Trigger initial count
        var event = document.createEvent('Event');
        event.initEvent('input', true, true);
        this.aboutInput.dispatchEvent(event);
    }
    
    // Education counter
    if (this.educationInput) {
        var educationCount = document.getElementById('educationCount');
        this.educationInput.addEventListener('input', function() {
            if (educationCount) {
                educationCount.textContent = this.value.length;
                educationCount.style.color = this.value.length > 1000 ? 'var(--danger)' : 'var(--text-primary)';
            }
        });
        // Trigger initial count
        var event = document.createEvent('Event');
        event.initEvent('input', true, true);
        this.educationInput.dispatchEvent(event);
    }
    
    // Experience counter
    if (this.experienceInput) {
        var experienceCount = document.getElementById('experienceCount');
        this.experienceInput.addEventListener('input', function() {
            if (experienceCount) {
                experienceCount.textContent = this.value.length;
                experienceCount.style.color = this.value.length > 1500 ? 'var(--danger)' : 'var(--text-primary)';
            }
        });
        // Trigger initial count
        var event = document.createEvent('Event');
        event.initEvent('input', true, true);
        this.experienceInput.dispatchEvent(event);
    }
};

CVBuilder.prototype.setupTextareaTools = function() {
    var self = this;
    
    // Format About button
    var formatAboutBtn = document.getElementById('formatAbout');
    if (formatAboutBtn) {
        formatAboutBtn.addEventListener('click', function() {
            self.formatTextarea(self.aboutInput);
            self.showToast('About section formatted', 'info');
        });
    }
    
    // Clear About button
    var clearAboutBtn = document.getElementById('clearAbout');
    if (clearAboutBtn) {
        clearAboutBtn.addEventListener('click', function() {
            if (confirm('Clear about section?')) {
                self.aboutInput.value = '';
                var event = document.createEvent('Event');
                event.initEvent('input', true, true);
                self.aboutInput.dispatchEvent(event);
                self.showToast('About section cleared', 'info');
            }
        });
    }
    
    // Add Education Example button
    var addEducationExampleBtn = document.getElementById('addEducationExample');
    if (addEducationExampleBtn) {
        addEducationExampleBtn.addEventListener('click', function() {
            self.addTextareaExample(self.educationInput, 'Bachelor of Science in Computer Science, University of Technology, 2020, GPA: 3.8\nDiploma in Web Development, Coding Academy, 2019');
            self.showToast('Education example added', 'info');
        });
    }
    
    // Clear Education button
    var clearEducationBtn = document.getElementById('clearEducation');
    if (clearEducationBtn) {
        clearEducationBtn.addEventListener('click', function() {
            if (confirm('Clear education section?')) {
                self.educationInput.value = '';
                var event = document.createEvent('Event');
                event.initEvent('input', true, true);
                self.educationInput.dispatchEvent(event);
                self.showToast('Education section cleared', 'info');
            }
        });
    }
    
    // Add Experience Example button
    var addExperienceExampleBtn = document.getElementById('addExperienceExample');
    if (addExperienceExampleBtn) {
        addExperienceExampleBtn.addEventListener('click', function() {
            self.addTextareaExample(self.experienceInput, 'Senior Developer, Tech Solutions Inc., 2020-Present, Led team of 5 developers\nJunior Developer, Startup Co., 2018-2020, Improved system performance by 40%');
            self.showToast('Experience example added', 'info');
        });
    }
    
    // Clear Experience button
    var clearExperienceBtn = document.getElementById('clearExperience');
    if (clearExperienceBtn) {
        clearExperienceBtn.addEventListener('click', function() {
            if (confirm('Clear experience section?')) {
                self.experienceInput.value = '';
                var event = document.createEvent('Event');
                event.initEvent('input', true, true);
                self.experienceInput.dispatchEvent(event);
                self.showToast('Experience section cleared', 'info');
            }
        });
    }
};

CVBuilder.prototype.formatTextarea = function(textarea) {
    if (!textarea) return;
    
    var text = textarea.value;
    
    // Basic formatting
    var formatted = text
        .replace(/\n\s*\n\s*\n/g, '\n\n') // Remove multiple empty lines
        .replace(/^/gm, function(match) { // Add proper paragraph spacing
            return match.trim() === '' ? match : '  ' + match;
        })
        .replace(/(^\s*\w|[\.\!\?]\s+\w)/g, function(c) { // Capitalize sentences
            return c.toUpperCase();
        })
        .trim();
    
    textarea.value = formatted;
    var event = document.createEvent('Event');
    event.initEvent('input', true, true);
    textarea.dispatchEvent(event);
};

CVBuilder.prototype.addTextareaExample = function(textarea, example) {
    if (!textarea) return;
    
    if (textarea.value.trim() === '') {
        textarea.value = example;
    } else {
        textarea.value += '\n\n' + example;
    }
    
    var event = document.createEvent('Event');
    event.initEvent('input', true, true);
    textarea.dispatchEvent(event);
    textarea.focus();
    textarea.scrollTop = textarea.scrollHeight;
};

CVBuilder.prototype.setupSkillsInput = function() {
    var self = this;
    
    if (this.skillsInput) {
        // Parse initial skills
        this.parseSkills();
        
        // Update skills on input
        this.skillsInput.addEventListener('input', function() {
            self.parseSkills();
        });
        
        // Add skill on comma or enter
        this.skillsInput.addEventListener('keydown', function(e) {
            if (e.key === ',' || e.key === 'Enter') {
                e.preventDefault();
                self.addSkillFromInput();
            }
        });
    }
};

CVBuilder.prototype.parseSkills = function() {
    if (!this.skillsInput || !this.skillsPreview) return;
    
    var skillsText = this.skillsInput.value;
    var skillArray = skillsText.split(',');
    var cleanedSkills = [];
    
    for (var i = 0; i < skillArray.length; i++) {
        var skill = skillArray[i].trim();
        if (skill.length > 0) {
            cleanedSkills.push(skill);
        }
    }
    
    this.skills = cleanedSkills;
    this.renderSkills();
};

CVBuilder.prototype.addSkillFromInput = function() {
    if (!this.skillsInput) return;
    
    var skill = this.skillsInput.value.trim();
    if (skill && this.skills.indexOf(skill) === -1) {
        this.skills.push(skill);
        this.skillsInput.value = '';
        this.renderSkills();
        this.showToast('Skill added: ' + skill, 'info');
    }
};

CVBuilder.prototype.renderSkills = function() {
    if (!this.skillsPreview) return;
    
    this.skillsPreview.innerHTML = '';
    
    for (var i = 0; i < this.skills.length; i++) {
        var skill = this.skills[i];
        var skillTag = document.createElement('div');
        skillTag.className = 'skill-tag';
        skillTag.innerHTML = skill +
            '<button class="remove-skill" data-index="' + i + '">' +
            '<i class="fas fa-times"></i>' +
            '</button>';
        
        this.skillsPreview.appendChild(skillTag);
    }
    
    // Add event listeners to remove buttons
    var removeButtons = this.skillsPreview.querySelectorAll('.remove-skill');
    for (var i = 0; i < removeButtons.length; i++) {
        (function(index) {
            removeButtons[index].addEventListener('click', function() {
                self.removeSkill(index);
            });
        })(i);
    }
    
    // Update skills input
    if (this.skillsInput) {
        this.skillsInput.value = this.skills.join(', ');
    }
};

CVBuilder.prototype.removeSkill = function(index) {
    if (index >= 0 && index < this.skills.length) {
        var removedSkill = this.skills[index];
        this.skills.splice(index, 1);
        this.renderSkills();
        this.showToast('Skill removed: ' + removedSkill, 'info');
    }
};

CVBuilder.prototype.setupFileUpload = function() {
    var self = this;
    
    if (this.attachmentsInput && this.uploadArea) {
        // Click to upload
        this.uploadArea.addEventListener('click', function(e) {
            if (e.target !== self.attachmentsInput) {
                self.attachmentsInput.click();
            }
        });
        
        // File selection
        this.attachmentsInput.addEventListener('change', function(e) {
            if (this.files) {
                var fileList = Array.prototype.slice.call(this.files);
                for (var i = 0; i < fileList.length; i++) {
                    self.handleFileSelection(fileList[i]);
                }
            }
        });
        
        // Drag and drop events
        var events = ['dragenter', 'dragover', 'dragleave', 'drop'];
        for (var i = 0; i < events.length; i++) {
            this.uploadArea.addEventListener(events[i], function(e) {
                e.preventDefault();
                e.stopPropagation();
            });
        }
        
        // Add drag over class
        this.uploadArea.addEventListener('dragenter', function() {
            self.uploadArea.classList.add('drag-over');
        });
        
        this.uploadArea.addEventListener('dragover', function() {
            self.uploadArea.classList.add('drag-over');
        });
        
        // Remove drag over class
        this.uploadArea.addEventListener('dragleave', function() {
            self.uploadArea.classList.remove('drag-over');
        });
        
        this.uploadArea.addEventListener('drop', function() {
            self.uploadArea.classList.remove('drag-over');
        });
        
        // Handle dropped files
        this.uploadArea.addEventListener('drop', function(e) {
            var files = e.dataTransfer.files;
            if (files) {
                var fileList = Array.prototype.slice.call(files);
                for (var i = 0; i < fileList.length; i++) {
                    self.handleFileSelection(fileList[i]);
                }
                // Note: Cannot set files property directly for security reasons
            }
        });
    }
    
    // Remove existing attachments
    var removeButtons = document.querySelectorAll('.btn-remove-attachment');
    for (var i = 0; i < removeButtons.length; i++) {
        removeButtons[i].addEventListener('click', function() {
            var fileName = this.getAttribute('data-file');
            self.removeExistingAttachment(fileName);
        });
    }
};

CVBuilder.prototype.handleFileSelection = function(file) {
    // Validate file type
    var validTypes = ['application/pdf', 'image/jpeg', 'image/png'];
    if (validTypes.indexOf(file.type) === -1) {
        this.showToast('Invalid file type. Please upload PDF, JPG, or PNG.', 'error');
        return;
    }
    
    // Validate file size (10MB)
    if (file.size > 10 * 1024 * 1024) {
        this.showToast('File size exceeds 10MB limit: ' + file.name, 'error');
        return;
    }
    
    // Add to files array
    this.files.push(file);
    
    // Create preview
    this.createFilePreview(file);
    
    this.showToast('File added: ' + file.name, 'success');
};

CVBuilder.prototype.createFilePreview = function(file) {
    if (!this.filePreviewContainer) return;
    
    var filePreview = document.createElement('div');
    filePreview.className = 'file-preview-item';
    filePreview.setAttribute('data-filename', file.name);
    
    var icon = file.type === 'application/pdf' ? 'fa-file-pdf' : 
               file.type.indexOf('image/') === 0 ? 'fa-file-image' : 'fa-file';
    
    filePreview.innerHTML = '<div class="file-preview-icon">' +
        '<i class="fas ' + icon + '"></i>' +
        '</div>' +
        '<div class="file-preview-info">' +
        '<h6>' + file.name + '</h6>' +
        '<span>' + this.formatFileSize(file.size) + '</span>' +
        '</div>' +
        '<div class="file-preview-progress">' +
        '<div class="progress-text">Ready to upload</div>' +
        '</div>' +
        '<button class="file-preview-remove" data-filename="' + file.name + '">' +
        '<i class="fas fa-times"></i>' +
        '</button>';
    
    this.filePreviewContainer.appendChild(filePreview);
    
    // Add remove event listener
    var removeBtn = filePreview.querySelector('.file-preview-remove');
    var self = this;
    removeBtn.addEventListener('click', function() {
        var fileName = this.getAttribute('data-filename');
        self.removeFile(fileName);
    });
};

CVBuilder.prototype.formatFileSize = function(bytes) {
    if (bytes === 0) return '0 Bytes';
    var k = 1024;
    var sizes = ['Bytes', 'KB', 'MB', 'GB'];
    var i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

CVBuilder.prototype.removeFile = function(fileName) {
    // Remove from files array
    var newFiles = [];
    for (var i = 0; i < this.files.length; i++) {
        if (this.files[i].name !== fileName) {
            newFiles.push(this.files[i]);
        }
    }
    this.files = newFiles;
    
    // Remove from DOM
    var filePreview = document.querySelector('.file-preview-item[data-filename="' + fileName + '"]');
    if (filePreview) {
        filePreview.remove();
    }
    
    this.showToast('File removed: ' + fileName, 'info');
};

CVBuilder.prototype.removeExistingAttachment = function(fileName) {
    if (confirm('Remove attachment: ' + fileName + '?')) {
        // In a real application, this would make an AJAX call to remove the file
        // For now, just show a message
        this.showToast('Attachment removal request sent for: ' + fileName, 'info');
        
        // Remove from DOM
        var attachmentItem = document.querySelector('.attachment-item button[data-file="' + fileName + '"]');
        if (attachmentItem && attachmentItem.parentNode && attachmentItem.parentNode.parentNode) {
            attachmentItem.parentNode.parentNode.remove();
        }
    }
};

CVBuilder.prototype.setupPreview = function() {
    var self = this;
    
    if (this.previewBtn) {
        this.previewBtn.addEventListener('click', function() {
            self.showPreview();
        });
    }
    
    // Preview modal
    var previewModal = document.getElementById('previewModal');
    var previewModalClose = document.getElementById('previewModalClose');
    var closePreview = document.getElementById('closePreview');
    var printPreview = document.getElementById('printPreview');
    var downloadPreview = document.getElementById('downloadPreview');
    
    if (previewModalClose) {
        previewModalClose.addEventListener('click', function() {
            self.hideModal(previewModal);
        });
    }
    
    if (closePreview) {
        closePreview.addEventListener('click', function() {
            self.hideModal(previewModal);
        });
    }
    
    if (printPreview) {
        printPreview.addEventListener('click', function() {
            self.printPreview();
        });
    }
    
    if (downloadPreview) {
        downloadPreview.addEventListener('click', function() {
            self.downloadPreview();
        });
    }
    
    if (previewModal) {
        previewModal.addEventListener('click', function(e) {
            if (e.target === previewModal) {
                self.hideModal(previewModal);
            }
        });
    }
};

CVBuilder.prototype.showPreview = function() {
    var previewModal = document.getElementById('previewModal');
    var previewContent = document.getElementById('previewContent');
    
    if (!previewModal || !previewContent) return;
    
    // Generate preview HTML
    var headline = this.headlineInput ? this.headlineInput.value : '';
    var about = this.aboutInput ? this.aboutInput.value : '';
    
    // Process education
    var education = [];
    if (this.educationInput && this.educationInput.value.trim()) {
        var eduLines = this.educationInput.value.split('\n');
        for (var i = 0; i < eduLines.length; i++) {
            if (eduLines[i].trim().length > 0) {
                education.push(eduLines[i]);
            }
        }
    }
    
    // Process experience
    var experience = [];
    if (this.experienceInput && this.experienceInput.value.trim()) {
        var expLines = this.experienceInput.value.split('\n');
        for (var i = 0; i < expLines.length; i++) {
            if (expLines[i].trim().length > 0) {
                experience.push(expLines[i]);
            }
        }
    }
    
    var skills = this.skills;
    
    var previewHTML = '<div class="preview-cv">' +
        '<div class="preview-header">' +
        '<h2>Curriculum Vitae</h2>' +
        '<div class="headline">' + (headline || 'Professional Profile') + '</div>' +
        '<div class="contact-info">' +
        '<span><i class="fas fa-calendar-alt"></i> Created: ' + new Date().toLocaleDateString() + '</span>' +
        '</div>' +
        '</div>' +
        '<div class="preview-section">' +
        '<h3>About</h3>' +
        '<p>' + (about || 'No information provided') + '</p>' +
        '</div>';
    
    // Add education section if exists
    if (education.length > 0) {
        previewHTML += '<div class="preview-section">' +
            '<h3>Education</h3>' +
            '<ul>';
        for (var i = 0; i < education.length; i++) {
            previewHTML += '<li>' + education[i] + '</li>';
        }
        previewHTML += '</ul>' +
            '</div>';
    }
    
    // Add experience section if exists
    if (experience.length > 0) {
        previewHTML += '<div class="preview-section">' +
            '<h3>Work Experience</h3>' +
            '<ul>';
        for (var i = 0; i < experience.length; i++) {
            previewHTML += '<li>' + experience[i] + '</li>';
        }
        previewHTML += '</ul>' +
            '</div>';
    }
    
    // Add skills section if exists
    if (skills.length > 0) {
        previewHTML += '<div class="preview-section">' +
            '<h3>Skills</h3>' +
            '<div class="skills-list">';
        for (var i = 0; i < skills.length; i++) {
            previewHTML += '<span>' + skills[i] + '</span>';
        }
        previewHTML += '</div>' +
            '</div>';
    }
    
    previewHTML += '</div>';
    
    previewContent.innerHTML = previewHTML;
    this.showModal(previewModal);
};

CVBuilder.prototype.printPreview = function() {
    var previewContent = document.getElementById('previewContent');
    if (previewContent) {
        var printWindow = window.open('', '_blank');
        printWindow.document.write('<!DOCTYPE html>' +
            '<html>' +
            '<head>' +
            '<title>CV Preview - Print</title>' +
            '<style>' +
            'body { font-family: Arial, sans-serif; padding: 20px; }' +
            '.preview-cv { max-width: 800px; margin: 0 auto; }' +
            '.preview-header { text-align: center; margin-bottom: 30px; }' +
            '.preview-header h2 { font-size: 28px; margin-bottom: 10px; }' +
            '.preview-section { margin-bottom: 25px; }' +
            '.preview-section h3 { border-bottom: 1px solid #333; padding-bottom: 5px; }' +
            '.skills-list { display: flex; flex-wrap: wrap; gap: 10px; }' +
            '.skills-list span { background: #f0f0f0; padding: 5px 15px; border-radius: 15px; }' +
            '@media print {' +
            '.no-print { display: none !important; }' +
            '}' +
            '</style>' +
            '</head>' +
            '<body>' +
            previewContent.innerHTML +
            '<div class="no-print" style="margin-top: 30px; text-align: center;">' +
            '<button onclick="window.close()" style="padding: 10px 20px; background: #dc3545; color: white; border: none; border-radius: 5px; cursor: pointer;">' +
            'Close Window' +
            '</button>' +
            '</div>' +
            '</body>' +
            '</html>');
        printWindow.document.close();
        printWindow.focus();
        printWindow.print();
    }
};

CVBuilder.prototype.downloadPreview = function() {
    this.showToast('PDF download feature would be implemented here', 'info');
};

CVBuilder.prototype.setupReset = function() {
    var self = this;
    
    if (this.resetBtn) {
        this.resetBtn.addEventListener('click', function() {
            self.showResetConfirmation();
        });
    }
    
    // Reset confirmation modal
    var resetModal = document.getElementById('resetConfirmationModal');
    var resetCancel = document.getElementById('resetCancel');
    var confirmReset = document.getElementById('confirmReset');
    
    if (resetCancel) {
        resetCancel.addEventListener('click', function() {
            self.hideModal(resetModal);
        });
    }
    
    if (confirmReset) {
        confirmReset.addEventListener('click', function() {
            self.resetForm();
            self.hideModal(resetModal);
        });
    }
    
    if (resetModal) {
        resetModal.addEventListener('click', function(e) {
            if (e.target === resetModal) {
                self.hideModal(resetModal);
            }
        });
    }
};

CVBuilder.prototype.showResetConfirmation = function() {
    var modal = document.getElementById('resetConfirmationModal');
    this.showModal(modal);
};

CVBuilder.prototype.resetForm = function() {
    // Reset form inputs
    if (this.headlineInput) this.headlineInput.value = '';
    if (this.aboutInput) this.aboutInput.value = '';
    if (this.educationInput) this.educationInput.value = '';
    if (this.experienceInput) this.experienceInput.value = '';
    if (this.skillsInput) this.skillsInput.value = '';
    if (this.attachmentsInput) this.attachmentsInput.value = '';
    
    // Reset skills
    this.skills = [];
    this.renderSkills();
    
    // Reset files
    this.files = [];
    if (this.filePreviewContainer) {
        this.filePreviewContainer.innerHTML = '';
    }
    
    // Reset to step 1
    this.currentStep = 1;
    this.updateStepUI();
    this.goToStep(1);
    
    // Clear localStorage
    localStorage.removeItem('cvBuilderDraft');
    localStorage.removeItem('cvBuilderCurrentStep');
    
    // Trigger input events to update counters
    var event = document.createEvent('Event');
    event.initEvent('input', true, true);
    
    if (this.headlineInput) this.headlineInput.dispatchEvent(event);
    if (this.aboutInput) this.aboutInput.dispatchEvent(event);
    if (this.educationInput) this.educationInput.dispatchEvent(event);
    if (this.experienceInput) this.experienceInput.dispatchEvent(event);
    
    this.showToast('Form reset successfully', 'success');
};

CVBuilder.prototype.setupModals = function() {
    // Modal functionality is already set up in other methods
};

CVBuilder.prototype.setupKeyboardShortcuts = function() {
    var self = this;
    
    document.addEventListener('keydown', function(e) {
        // Ctrl+Right arrow to next step
        if (e.ctrlKey && e.key === 'ArrowRight') {
            e.preventDefault();
            if (self.validateCurrentStep()) {
                self.nextStep();
            }
        }
        
        // Ctrl+Left arrow to previous step
        if (e.ctrlKey && e.key === 'ArrowLeft') {
            e.preventDefault();
            self.prevStep();
        }
        
        // Ctrl+P to preview
        if (e.ctrlKey && e.key === 'p') {
            e.preventDefault();
            self.showPreview();
        }
        
        // Ctrl+S to save (when on last step)
        if (e.ctrlKey && e.key === 's') {
            e.preventDefault();
            if (self.currentStep === self.totalSteps && self.validateForm()) {
                self.form.submit();
            }
        }
        
        // Escape to close modals
        if (e.key === 'Escape') {
            var previewModal = document.getElementById('previewModal');
            var resetModal = document.getElementById('resetConfirmationModal');
            
            if (previewModal && previewModal.style.display === 'flex') {
                self.hideModal(previewModal);
            }
            if (resetModal && resetModal.style.display === 'flex') {
                self.hideModal(resetModal);
            }
        }
    });
};

CVBuilder.prototype.setupFadeAnimations = function() {
    var fadeElements = document.querySelectorAll('.fade-in');
    
    for (var i = 0; i < fadeElements.length; i++) {
        var element = fadeElements[i];
        element.style.opacity = '0';
        element.style.transform = 'translateY(20px)';
        element.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        
        (function(el) {
            setTimeout(function() {
                el.style.opacity = '1';
                el.style.transform = 'translateY(0)';
            }, 100);
        })(element);
    }
    
    // Also fade in alerts if present
    var alerts = document.querySelectorAll('.alert');
    for (var i = 0; i < alerts.length; i++) {
        alerts[i].style.animation = 'fadeIn 0.5s ease';
    }
};

CVBuilder.prototype.formHasChanges = function() {
    var hasChanges = false;
    
    if (this.headlineInput && this.headlineInput.value.trim()) hasChanges = true;
    if (this.aboutInput && this.aboutInput.value.trim()) hasChanges = true;
    if (this.educationInput && this.educationInput.value.trim()) hasChanges = true;
    if (this.experienceInput && this.experienceInput.value.trim()) hasChanges = true;
    if (this.skillsInput && this.skillsInput.value.trim()) hasChanges = true;
    if (this.files.length > 0) hasChanges = true;
    
    return hasChanges;
};

CVBuilder.prototype.saveDraft = function() {
    var draft = {
        headline: this.headlineInput ? this.headlineInput.value : '',
        about: this.aboutInput ? this.aboutInput.value : '',
        education: this.educationInput ? this.educationInput.value : '',
        experience: this.experienceInput ? this.experienceInput.value : '',
        skills: this.skills,
        currentStep: this.currentStep,
        timestamp: new Date().toISOString()
    };
    
    localStorage.setItem('cvBuilderDraft', JSON.stringify(draft));
};

CVBuilder.prototype.loadDraft = function() {
    var draft = localStorage.getItem('cvBuilderDraft');
    var savedStep = localStorage.getItem('cvBuilderCurrentStep');
    
    if (draft) {
        try {
            var draftData = JSON.parse(draft);
            
            // Load form data
            if (this.headlineInput) this.headlineInput.value = draftData.headline || '';
            if (this.aboutInput) this.aboutInput.value = draftData.about || '';
            if (this.educationInput) this.educationInput.value = draftData.education || '';
            if (this.experienceInput) this.experienceInput.value = draftData.experience || '';
            
            // Load skills
            if (draftData.skills && Array.isArray(draftData.skills)) {
                this.skills = draftData.skills;
                this.renderSkills();
            }
            
            // Load step
            if (savedStep) {
                this.currentStep = parseInt(savedStep);
                this.goToStep(this.currentStep);
            }
            
            // Trigger input events to update counters
            var event = document.createEvent('Event');
            event.initEvent('input', true, true);
            
            if (this.headlineInput) this.headlineInput.dispatchEvent(event);
            if (this.aboutInput) this.aboutInput.dispatchEvent(event);
            if (this.educationInput) this.educationInput.dispatchEvent(event);
            if (this.experienceInput) this.experienceInput.dispatchEvent(event);
            
            this.showToast('Loaded draft from previous session', 'info');
        } catch (e) {
            console.error('Error loading draft:', e);
        }
    }
};

CVBuilder.prototype.showModal = function(modal) {
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
};

CVBuilder.prototype.hideModal = function(modal) {
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
};

CVBuilder.prototype.showToast = function(message, type) {
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
            style.textContent = '@keyframes slideIn {' +
                'from { opacity: 0; transform: translateY(20px); }' +
                'to { opacity: 1; transform: translateY(0); }' +
                '}' +
                '@keyframes slideOut {' +
                'from { opacity: 1; transform: translateY(0); }' +
                'to { opacity: 0; transform: translateY(20px); }' +
                '}' +
                '.toast {' +
                'background: white; border-radius: 8px; padding: 15px 20px; ' +
                'box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; ' +
                'align-items: center; gap: 12px; min-width: 300px; ' +
                'max-width: 400px; opacity: 0; transform: translateY(20px); ' +
                'transition: all 0.3s ease; border-left: 4px solid #3b82f6;' +
                '}' +
                '.toast.show { opacity: 1; transform: translateY(0); }' +
                '.toast.hide { opacity: 0; transform: translateY(20px); }' +
                '.toast.success { border-left-color: #10b981; }' +
                '.toast.error { border-left-color: #ef4444; }' +
                '.toast.info { border-left-color: #3b82f6; }' +
                '.toast.warning { border-left-color: #f59e0b; }' +
                '.toast-icon { font-size: 1.2rem; }' +
                '.toast.success .toast-icon { color: #10b981; }' +
                '.toast.error .toast-icon { color: #ef4444; }' +
                '.toast.info .toast-icon { color: #3b82f6; }' +
                '.toast.warning .toast-icon { color: #f59e0b; }' +
                '.toast-content { flex: 1; }' +
                '.toast-content p { margin: 0; color: #374151; font-size: 0.9rem; }' +
                '.toast-close { background: none; border: none; color: #9ca3af; ' +
                'cursor: pointer; padding: 0; font-size: 0.9rem; transition: color 0.2s; }' +
                '.toast-close:hover { color: #374151; }';
            document.head.appendChild(style);
        }
    }
    
    var toast = document.createElement('div');
    toast.className = 'toast ' + type;
    
    var iconClass = 'fa-info-circle';
    if (type === 'success') iconClass = 'fa-check-circle';
    else if (type === 'error') iconClass = 'fa-exclamation-circle';
    else if (type === 'warning') iconClass = 'fa-exclamation-triangle';
    
    toast.innerHTML = '<div class="toast-icon">' +
        '<i class="fas ' + iconClass + '"></i>' +
        '</div>' +
        '<div class="toast-content">' +
        '<p>' + message + '</p>' +
        '</div>' +
        '<button class="toast-close">' +
        '<i class="fas fa-times"></i>' +
        '</button>';
    
    toastContainer.appendChild(toast);
    
    // Add show animation
    var self = this;
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
    var closeBtn = toast.querySelector('.toast-close');
    closeBtn.addEventListener('click', function() {
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
    fadeStyle.textContent = '@keyframes fadeIn {' +
        'from { opacity: 0; transform: translateY(-10px); }' +
        'to { opacity: 1; transform: translateY(0); }' +
        '}' +
        '.alert { animation: fadeIn 0.5s ease; }';
    document.head.appendChild(fadeStyle);
}

// Initialize the CV builder
document.addEventListener('DOMContentLoaded', function() {
    // Check if we're on the CV builder page
    if (document.querySelector('.cv-builder-form')) {
        new CVBuilder();
    }
});