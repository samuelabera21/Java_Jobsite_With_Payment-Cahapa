/**
 * View Applications Management
 * Enhanced with filtering, searching, and interactive features
 * @class ViewApplications
 * @version 1.0.0
 */

/* global document, window, localStorage, console */

function ViewApplications() {
    this.applications = document.querySelectorAll('.application-card');
    this.searchInput = document.getElementById('searchApplications');
    this.statusFilter = document.getElementById('statusFilter');
    this.currentWithdrawId = null;
    
    this.init();
}

ViewApplications.prototype.init = function() {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', this.setup.bind(this));
    } else {
        this.setup();
    }
};

ViewApplications.prototype.setup = function() {
    this.setupSearch();
    this.setupFilter();
    this.setupModals();
    this.setupWithdraw();
    this.setupPrint();
    this.setupPagination();
    this.setupKeyboardShortcuts();
    this.updateStats();
};

ViewApplications.prototype.setupSearch = function() {
    var self = this;
    
    if (this.searchInput) {
        this.searchInput.addEventListener('input', function() {
            var searchTerm = this.value.toLowerCase().trim();
            self.filterApplications();
        });
    }
};

ViewApplications.prototype.setupFilter = function() {
    var self = this;
    
    if (this.statusFilter) {
        this.statusFilter.addEventListener('change', function() {
            self.filterApplications();
        });
    }
};

ViewApplications.prototype.filterApplications = function() {
    var searchTerm = this.searchInput ? this.searchInput.value.toLowerCase().trim() : '';
    var statusFilter = this.statusFilter ? this.statusFilter.value : '';
    var visibleCount = 0;
    
    this.applications.forEach(function(card) {
        var jobTitle = card.querySelector('.job-title').textContent.toLowerCase();
        var location = card.querySelector('.location').textContent.toLowerCase();
        var status = card.getAttribute('data-status');
        var message = card.querySelector('.message-preview').textContent.toLowerCase();
        
        var matchesSearch = searchTerm === '' || 
                           jobTitle.includes(searchTerm) || 
                           location.includes(searchTerm) ||
                           message.includes(searchTerm);
        
        var matchesFilter = statusFilter === '' || status === statusFilter;
        
        if (matchesSearch && matchesFilter) {
            card.style.display = 'block';
            visibleCount++;
            
            // Add fade-in animation
            card.classList.add('fade-in');
        } else {
            card.style.display = 'none';
        }
    });
    
    // Update showing count
    var showingCount = document.getElementById('showingCount');
    if (showingCount) {
        showingCount.textContent = visibleCount;
    }
    
    // Show/hide empty state
    var emptyState = document.querySelector('.empty-state');
    if (emptyState) {
        emptyState.style.display = visibleCount === 0 ? 'block' : 'none';
    }
};

ViewApplications.prototype.setupModals = function() {
    var self = this;
    
    // Application Details Modal
    var detailsModal = document.getElementById('applicationDetailsModal');
    var detailsModalClose = document.getElementById('detailsModalClose');
    var closeDetailsModalBtn = document.getElementById('closeDetailsModal');
    var viewDetailsBtns = document.querySelectorAll('.view-details');
    
    if (detailsModal && detailsModalClose) {
        // Close button
        detailsModalClose.addEventListener('click', function() {
            self.hideModal(detailsModal);
        });
        
        // Close on background click
        detailsModal.addEventListener('click', function(e) {
            if (e.target === detailsModal) {
                self.hideModal(detailsModal);
            }
        });
    }
    
    if (closeDetailsModalBtn) {
        closeDetailsModalBtn.addEventListener('click', function() {
            self.hideModal(detailsModal);
        });
    }
    
    // View details buttons
    viewDetailsBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var appId = this.getAttribute('data-app-id');
            self.showApplicationDetails(appId);
        });
    });
    
    // Withdraw Confirmation Modal
    var withdrawModal = document.getElementById('withdrawConfirmationModal');
    var withdrawCancel = document.getElementById('withdrawCancel');
    
    if (withdrawCancel) {
        withdrawCancel.addEventListener('click', function() {
            self.hideModal(withdrawModal);
            self.currentWithdrawId = null;
        });
    }
    
    if (withdrawModal) {
        withdrawModal.addEventListener('click', function(e) {
            if (e.target === withdrawModal) {
                self.hideModal(withdrawModal);
                self.currentWithdrawId = null;
            }
        });
    }
};

ViewApplications.prototype.showModal = function(modal) {
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
};

ViewApplications.prototype.hideModal = function(modal) {
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
};

ViewApplications.prototype.showApplicationDetails = function(appId) {
    var self = this;
    var modal = document.getElementById('applicationDetailsModal');
    var modalBody = document.getElementById('detailsModalBody');
    
    // Find the application card
    var appCard = document.querySelector('.view-details[data-app-id="' + appId + '"]').closest('.application-card');
    
    if (appCard && modalBody) {
        var jobTitle = appCard.querySelector('.job-title').textContent;
        var location = appCard.querySelector('.location').textContent;
        var appliedDate = appCard.querySelector('.applied-date').textContent.replace('Applied: ', '');
        var statusBadge = appCard.querySelector('.status-badge').cloneNode(true);
        var message = appCard.querySelector('.message-preview').innerHTML;
        var appIdText = appCard.querySelector('.application-id').textContent;
        
        // Get additional details
        var salary = '';
        var salaryElement = appCard.querySelector('.salary-highlight');
        if (salaryElement) {
            salary = salaryElement.textContent;
        }
        
        var jobType = '';
        var jobTypeElement = appCard.querySelector('.detail-row:nth-child(3) .detail-value');
        if (jobTypeElement) {
            jobType = jobTypeElement.textContent;
        }
        
        // Build modal content
        modalBody.innerHTML = `
            <div class="application-details-modal">
                <div class="detail-header">
                    <div class="job-info">
                        <h4>${jobTitle}</h4>
                        <div class="job-meta">
                            <span class="location">
                                <i class="fas fa-map-marker-alt"></i>
                                ${location}
                            </span>
                        </div>
                    </div>
                    <div class="status-container">
                        ${statusBadge.outerHTML}
                    </div>
                </div>
                
                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-hashtag"></i>
                            Application ID
                        </div>
                        <div class="detail-value">${appIdText}</div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-calendar-alt"></i>
                            Applied Date
                        </div>
                        <div class="detail-value">${appliedDate}</div>
                    </div>
                    
                    ${salary ? `
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-money-bill-wave"></i>
                            Salary
                        </div>
                        <div class="detail-value salary-highlight">${salary}</div>
                    </div>
                    ` : ''}
                    
                    ${jobType ? `
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-briefcase"></i>
                            Job Type
                        </div>
                        <div class="detail-value">${jobType}</div>
                    </div>
                    ` : ''}
                </div>
                
                <div class="message-section">
                    <h5>
                        <i class="fas fa-envelope"></i>
                        Application Message
                    </h5>
                    <div class="message-content">
                        ${message}
                    </div>
                </div>
                
                <div class="timeline-section">
                    <h5>
                        <i class="fas fa-history"></i>
                        Application Timeline
                    </h5>
                    <div class="timeline">
                        <div class="timeline-item active">
                            <div class="timeline-dot"></div>
                            <div class="timeline-content">
                                <h6>Application Submitted</h6>
                                <p>${appliedDate}</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-dot"></div>
                            <div class="timeline-content">
                                <h6>Under Review</h6>
                                <p>Application is being reviewed by employer</p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-dot"></div>
                            <div class="timeline-content">
                                <h6>Decision Made</h6>
                                <p>Awaiting final decision</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        this.showModal(modal);
    }
};

ViewApplications.prototype.setupWithdraw = function() {
    var self = this;
    var withdrawBtns = document.querySelectorAll('.withdraw-btn');
    var confirmWithdrawBtn = document.getElementById('confirmWithdraw');
    
    // Setup withdraw buttons
    withdrawBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var appId = this.getAttribute('data-app-id');
            self.showWithdrawConfirmation(appId);
        });
    });
    
    // Confirm withdraw
    if (confirmWithdrawBtn) {
        confirmWithdrawBtn.addEventListener('click', function() {
            if (self.currentWithdrawId) {
                self.withdrawApplication(self.currentWithdrawId);
            }
        });
    }
};

ViewApplications.prototype.showWithdrawConfirmation = function(appId) {
    this.currentWithdrawId = appId;
    var modal = document.getElementById('withdrawConfirmationModal');
    this.showModal(modal);
};

ViewApplications.prototype.withdrawApplication = function(appId) {
    var self = this;
    var modal = document.getElementById('withdrawConfirmationModal');
    
    // Show loading
    this.showLoading();
    
    // Simulate API call
    setTimeout(function() {
        self.hideLoading();
        self.hideModal(modal);
        
        // Find and remove the application card
        var appCard = document.querySelector('.withdraw-btn[data-app-id="' + appId + '"]').closest('.application-card');
        if (appCard) {
            appCard.style.opacity = '0.5';
            
            setTimeout(function() {
                appCard.remove();
                self.showToast('Application withdrawn successfully', 'success');
                self.updateStats();
                self.filterApplications(); // Refresh filtered list
            }, 500);
        }
        
        self.currentWithdrawId = null;
    }, 1500);
};

ViewApplications.prototype.setupPrint = function() {
    var self = this;
    var printBtn = document.getElementById('printApplication');
    
    if (printBtn) {
        printBtn.addEventListener('click', function() {
            self.printApplicationDetails();
        });
    }
};

ViewApplications.prototype.printApplicationDetails = function() {
    var modalBody = document.getElementById('detailsModalBody');
    
    if (modalBody) {
        var printContent = modalBody.innerHTML;
        var originalContent = document.body.innerHTML;
        
        document.body.innerHTML = `
            <!DOCTYPE html>
            <html>
            <head>
                <title>Application Details - Print</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    body { font-family: Arial, sans-serif; padding: 20px; }
                    .print-header { text-align: center; margin-bottom: 30px; }
                    .print-header h2 { color: #333; }
                    .print-section { margin-bottom: 20px; }
                    .print-label { font-weight: bold; color: #666; }
                    .message-content { border: 1px solid #ddd; padding: 15px; margin-top: 10px; }
                    @media print {
                        .no-print { display: none !important; }
                    }
                </style>
            </head>
            <body>
                <div class="print-header">
                    <h2>Application Details</h2>
                    <p>Printed on ${new Date().toLocaleDateString()}</p>
                </div>
                ${printContent}
                <div class="no-print" style="margin-top: 30px; text-align: center;">
                    <button onclick="window.close()" style="padding: 10px 20px; background: #dc3545; color: white; border: none; border-radius: 5px; cursor: pointer;">
                        Close Window
                    </button>
                </div>
            </body>
            </html>
        `;
        
        window.print();
        document.body.innerHTML = originalContent;
        location.reload(); // Reload to restore original state
    }
};

ViewApplications.prototype.setupPagination = function() {
    var prevBtn = document.getElementById('prevPage');
    var nextBtn = document.getElementById('nextPage');
    
    if (prevBtn) {
        prevBtn.addEventListener('click', this.prevPage.bind(this));
    }
    
    if (nextBtn) {
        nextBtn.addEventListener('click', this.nextPage.bind(this));
    }
};

ViewApplications.prototype.prevPage = function() {
    // Implement pagination logic here
    this.showToast('Previous page', 'info');
};

ViewApplications.prototype.nextPage = function() {
    // Implement pagination logic here
    this.showToast('Next page', 'info');
};

ViewApplications.prototype.updateStats = function() {
    var total = this.applications.length;
    var pending = document.querySelectorAll('.application-card.pending').length;
    var reviewed = document.querySelectorAll('.application-card.reviewed').length;
    var accepted = document.querySelectorAll('.application-card.accepted').length;
    var rejected = document.querySelectorAll('.application-card.rejected').length;
    
    // Update stats in UI if needed
    var stats = {
        total: total,
        pending: pending,
        reviewed: reviewed,
        accepted: accepted,
        rejected: rejected
    };
    
    return stats;
};

ViewApplications.prototype.setupKeyboardShortcuts = function() {
    var self = this;
    
    document.addEventListener('keydown', function(e) {
        // Escape to close modals
        if (e.key === 'Escape') {
            var detailsModal = document.getElementById('applicationDetailsModal');
            var withdrawModal = document.getElementById('withdrawConfirmationModal');
            
            if (detailsModal.style.display === 'flex') {
                self.hideModal(detailsModal);
            }
            if (withdrawModal.style.display === 'flex') {
                self.hideModal(withdrawModal);
                self.currentWithdrawId = null;
            }
        }
        
        // Ctrl+F to focus search
        if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
            e.preventDefault();
            if (self.searchInput) {
                self.searchInput.focus();
            }
        }
    });
};

ViewApplications.prototype.showLoading = function() {
    var loadingOverlay = document.getElementById('loadingOverlay');
    if (loadingOverlay) {
        loadingOverlay.style.display = 'flex';
    }
};

ViewApplications.prototype.hideLoading = function() {
    var loadingOverlay = document.getElementById('loadingOverlay');
    if (loadingOverlay) {
        loadingOverlay.style.display = 'none';
    }
};

ViewApplications.prototype.showToast = function(message, type) {
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
    new ViewApplications();
});