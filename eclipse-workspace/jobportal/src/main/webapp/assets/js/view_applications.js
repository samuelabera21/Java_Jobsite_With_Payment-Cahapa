/**
 * View Applications Management
 * @class ViewApplications
 * @version 1.0.0
 */

// Main ViewApplications class
function ViewApplications() {
    // Current theme
    this.currentTheme = localStorage.getItem('adminTheme') || 'light';
    
    // Confirmation action href
    this.confirmHref = null;
    
    // Current sort field
    this.sortField = 'id';
    
    // Current sort direction
    this.sortDirection = 'asc';
    
    // All applications data
    this.allApplications = [];
    
    // Filtered applications data
    this.filteredApplications = [];
    
    // Current status filter
    this.statusFilter = '';
    
    // Current job filter
    this.jobFilter = '';
    
    // Current search term
    this.searchTerm = '';
    
    this.init();
}

/**
 * Initialize the application
 */
ViewApplications.prototype.init = function() {
    var self = this;
    
    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            self.setup();
        });
    } else {
        this.setup();
    }
};

/**
 * Set up all components
 */
ViewApplications.prototype.setup = function() {
    this.loadApplicationsData();
    this.setupTheme();
    this.setupConfirmations();
    this.setupFilters();
    this.setupSearch();
    this.setupSorting();
    this.setupTableInteractions();
    this.setupExport();
    this.setupAnalytics();
    this.setupAnimations();
    this.setupLoading();
    this.setupNotifications();
    this.applyFilters();
};

/**
 * Load applications data from table
 */
ViewApplications.prototype.loadApplicationsData = function() {
    var rows = document.querySelectorAll('.seeker-row');
    this.allApplications = [];
    
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        var id = parseInt(row.dataset.applicationId, 10);
        var jobId = row.dataset.jobId;
        var applicantId = row.dataset.applicantId;
        var status = row.dataset.status;
        var applied = row.dataset.applied;
        
        // Get other data from DOM elements
        var messageElement = row.querySelectorAll('.email-link')[1];
        var message = messageElement ? messageElement.title || messageElement.textContent : '';
        var cvElement = row.querySelectorAll('.email-link')[2];
        var hasCV = cvElement && cvElement.textContent !== 'No CV';
        
        this.allApplications.push({
            id: id,
            jobId: jobId,
            applicantId: applicantId,
            status: status,
            message: message,
            hasCV: hasCV,
            applied: applied,
            element: row
        });
    }
    
    this.filteredApplications = this.allApplications.slice();
};

/**
 * Set up theme toggle functionality
 */
ViewApplications.prototype.setupTheme = function() {
    var self = this;
    var themeToggle = document.getElementById('themeToggle');
    
    // Apply saved theme
    if (this.currentTheme === 'dark') {
        document.body.classList.add('dark');
        this.updateThemeButton('light');
    } else {
        document.body.classList.remove('dark');
        this.updateThemeButton('dark');
    }
    
    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            self.toggleTheme();
        });
    }
};

/**
 * Toggle between light and dark themes
 */
ViewApplications.prototype.toggleTheme = function() {
    var body = document.body;
    
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
};

/**
 * Update theme button text and icon
 */
ViewApplications.prototype.updateThemeButton = function(targetTheme) {
    var themeToggle = document.getElementById('themeToggle');
    if (!themeToggle) {
        return;
    }
    
    if (targetTheme === 'light') {
        themeToggle.innerHTML = '<i class="fas fa-sun"></i><span>Light Mode</span>';
    } else {
        themeToggle.innerHTML = '<i class="fas fa-moon"></i><span>Dark Mode</span>';
    }
};

/**
 * Set up confirmation dialogs for actions
 */
ViewApplications.prototype.setupConfirmations = function() {
    var self = this;
    
    // Handle action buttons with confirmation
    document.addEventListener('click', function(e) {
        var actionBtn = e.target.closest('[data-confirm]');
        if (actionBtn) {
            e.preventDefault();
            self.showConfirmation(actionBtn);
        }
    });
    
    // Setup confirmation modal buttons
    var cancelBtn = document.getElementById('confirmCancel');
    var okBtn = document.getElementById('confirmOk');
    var modal = document.getElementById('confirmationModal');
    
    if (cancelBtn) {
        cancelBtn.addEventListener('click', function() {
            if (modal) {
                modal.classList.remove('active');
            }
        });
    }
    
    if (okBtn) {
        okBtn.addEventListener('click', function() {
            if (self.confirmHref) {
                window.location.href = self.confirmHref;
            }
            if (modal) {
                modal.classList.remove('active');
            }
        });
    }
    
    // Close modal on backdrop click
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.classList.remove('active');
            }
        });
    }
};

/**
 * Show confirmation dialog
 */
ViewApplications.prototype.showConfirmation = function(button) {
    var action = button.getAttribute('data-confirm');
    var href = button.getAttribute('href');
    var modal = document.getElementById('confirmationModal');
    var title = document.getElementById('confirmTitle');
    var message = document.getElementById('confirmMessage');
    
    if (!modal || !title || !message || !href) {
        return;
    }
    
    this.confirmHref = href;
    
    // Set messages based on action
    switch (action) {
        case 'accept':
            title.textContent = 'Accept Application';
            message.textContent = 'Are you sure you want to accept this job application? The applicant will be notified.';
            break;
        case 'reject':
            title.textContent = 'Reject Application';
            message.textContent = 'Are you sure you want to reject this job application? The applicant will be notified.';
            break;
        case 'delete':
            title.textContent = 'Delete Application';
            message.textContent = 'Are you sure you want to delete this application? This action cannot be undone.';
            break;
        default:
            title.textContent = 'Confirm Action';
            message.textContent = 'Are you sure you want to perform this action?';
    }
    
    modal.classList.add('active');
};

/**
 * Set up filter functionality
 */
ViewApplications.prototype.setupFilters = function() {
    var self = this;
    var statusFilter = document.getElementById('statusFilter');
    var jobFilter = document.getElementById('jobFilter');
    var clearFiltersBtn = document.getElementById('clearFilters');
    
    if (statusFilter) {
        statusFilter.addEventListener('change', function() {
            self.statusFilter = statusFilter.value;
            self.applyFilters();
        });
    }
    
    if (jobFilter) {
        jobFilter.addEventListener('change', function() {
            self.jobFilter = jobFilter.value;
            self.applyFilters();
        });
    }
    
    if (clearFiltersBtn) {
        clearFiltersBtn.addEventListener('click', function() {
            self.clearFilters();
        });
    }
};

/**
 * Set up search functionality
 */
ViewApplications.prototype.setupSearch = function() {
    var self = this;
    var searchInput = document.getElementById('searchInput');
    var searchBtn = document.getElementById('searchBtn');
    
    if (searchInput) {
        // Update search term on input
        searchInput.addEventListener('input', function(e) {
            self.searchTerm = e.target.value.toLowerCase().trim();
        });
        
        // Search on Enter key
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                self.applyFilters();
            }
        });
    }
    
    if (searchBtn) {
        searchBtn.addEventListener('click', function() {
            self.applyFilters();
        });
    }
};

/**
 * Set up table sorting
 */
ViewApplications.prototype.setupSorting = function() {
    var self = this;
    var sortButtons = document.querySelectorAll('.sort-btn');
    
    for (var i = 0; i < sortButtons.length; i++) {
        sortButtons[i].addEventListener('click', function(e) {
            var sortField = this.dataset.sort;
            self.toggleSort(sortField);
        });
    }
};

/**
 * Toggle sort field and direction
 */
ViewApplications.prototype.toggleSort = function(field) {
    // If same field, toggle direction
    if (this.sortField === field) {
        this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
    } else {
        // New field, default to ascending
        this.sortField = field;
        this.sortDirection = 'asc';
    }
    
    this.applySorting();
    this.updateSortIndicators();
};

/**
 * Apply sorting to filtered applications
 */
ViewApplications.prototype.applySorting = function() {
    var self = this;
    
    this.filteredApplications.sort(function(a, b) {
        var valueA, valueB;
        
        switch (self.sortField) {
            case 'job':
                valueA = parseInt(a.jobId, 10);
                valueB = parseInt(b.jobId, 10);
                break;
            case 'applicant':
                valueA = parseInt(a.applicantId, 10);
                valueB = parseInt(b.applicantId, 10);
                break;
            case 'message':
                valueA = a.message ? a.message.toLowerCase() : '';
                valueB = b.message ? b.message.toLowerCase() : '';
                break;
            case 'cv':
                valueA = a.hasCV ? 1 : 0;
                valueB = b.hasCV ? 1 : 0;
                break;
            case 'status':
                valueA = a.status;
                valueB = b.status;
                break;
            case 'applied':
                valueA = parseInt(a.applied, 10);
                valueB = parseInt(b.applied, 10);
                break;
            case 'id':
            default:
                valueA = a.id;
                valueB = b.id;
                break;
        }
        
        if (self.sortDirection === 'asc') {
            return valueA > valueB ? 1 : -1;
        } else {
            return valueA < valueB ? 1 : -1;
        }
    });
    
    this.updateTable();
};

/**
 * Update sort indicators in table header
 */
ViewApplications.prototype.updateSortIndicators = function() {
    var sortButtons = document.querySelectorAll('.sort-btn');
    var self = this;
    
    for (var i = 0; i < sortButtons.length; i++) {
        var button = sortButtons[i];
        var icon = button.querySelector('i');
        var field = button.dataset.sort;
        
        if (field === self.sortField) {
            icon.className = self.sortDirection === 'asc' ? 'fas fa-sort-up' : 'fas fa-sort-down';
            icon.style.color = 'var(--primary)';
        } else {
            icon.className = 'fas fa-sort';
            icon.style.color = 'var(--text-muted)';
        }
    }
};

/**
 * Apply filters and search
 */
ViewApplications.prototype.applyFilters = function() {
    var self = this;
    
    this.filteredApplications = this.allApplications.filter(function(app) {
        // Apply status filter
        var matchesStatus = !self.statusFilter || app.status === self.statusFilter;
        
        // Apply job filter
        var matchesJob = !self.jobFilter || app.jobId === self.jobFilter;
        
        // Apply search filter
        var matchesSearch = !self.searchTerm || 
            app.id.toString().includes(self.searchTerm) ||
            app.jobId.includes(self.searchTerm) ||
            app.applicantId.includes(self.searchTerm) ||
            (app.message && app.message.toLowerCase().includes(self.searchTerm));
        
        return matchesStatus && matchesJob && matchesSearch;
    });
    
    this.applySorting();
    this.updateStats();
    this.showToast('Found ' + this.filteredApplications.length + ' applications', 'info');
};

/**
 * Clear all filters
 */
ViewApplications.prototype.clearFilters = function() {
    var statusFilter = document.getElementById('statusFilter');
    var jobFilter = document.getElementById('jobFilter');
    var searchInput = document.getElementById('searchInput');
    
    if (statusFilter) {
        statusFilter.value = '';
    }
    
    if (jobFilter) {
        jobFilter.value = '';
    }
    
    if (searchInput) {
        searchInput.value = '';
    }
    
    this.statusFilter = '';
    this.jobFilter = '';
    this.searchTerm = '';
    
    this.applyFilters();
    this.showToast('Filters cleared', 'info');
};

/**
 * Update table with filtered and sorted data
 */
ViewApplications.prototype.updateTable = function() {
    var tbody = document.getElementById('seekersTableBody');
    if (!tbody) return;
    
    // Clear existing rows (except empty row)
    var existingRows = tbody.querySelectorAll('.seeker-row');
    for (var i = 0; i < existingRows.length; i++) {
        existingRows[i].remove();
    }
    
    if (this.filteredApplications.length === 0) {
        // Show empty state if it doesn't exist
        if (!tbody.querySelector('.empty-row')) {
            var emptyRow = document.createElement('tr');
            emptyRow.className = 'empty-row fade-in';
            emptyRow.innerHTML = '<td colspan="8" class="empty-state">' +
                '<i class="fas fa-file-alt"></i>' +
                '<h4>No Applications Found</h4>' +
                '<p>No applications match your search criteria. Try adjusting your filters.</p>' +
                '</td>';
            tbody.appendChild(emptyRow);
        }
    } else {
        // Remove empty row if it exists
        var emptyRow = tbody.querySelector('.empty-row');
        if (emptyRow) {
            emptyRow.remove();
        }
        
        // Add filtered and sorted rows
        for (var i = 0; i < this.filteredApplications.length; i++) {
            var app = this.filteredApplications[i];
            app.element.style.order = i;
            app.element.style.animationDelay = (i * 0.1) + 's';
            app.element.classList.add('fade-in');
            tbody.appendChild(app.element);
        }
    }
};

/**
 * Update statistics display
 */
ViewApplications.prototype.updateStats = function() {
    var totalApps = this.filteredApplications.length;
    var pendingApps = this.filteredApplications.filter(function(a) {
        return a.status === 'pending';
    }).length;
    var reviewedApps = this.filteredApplications.filter(function(a) {
        return a.status === 'reviewed';
    }).length;
    var acceptedApps = this.filteredApplications.filter(function(a) {
        return a.status === 'accepted';
    }).length;
    var rejectedApps = this.filteredApplications.filter(function(a) {
        return a.status === 'rejected';
    }).length;
    
    // Update stats cards
    var totalEl = document.getElementById('totalApplications');
    var pendingEl = document.getElementById('pendingApplications');
    var reviewedEl = document.getElementById('reviewedApplications');
    var acceptedEl = document.getElementById('acceptedApplications');
    
    if (totalEl) totalEl.textContent = totalApps;
    if (pendingEl) pendingEl.textContent = pendingApps;
    if (reviewedEl) reviewedEl.textContent = reviewedApps;
    if (acceptedEl) acceptedEl.textContent = acceptedApps;
    
    // Update progress bars
    this.updateProgressBars(totalApps, pendingApps, reviewedApps, acceptedApps, rejectedApps);
};

/**
 * Update progress bars
 */
ViewApplications.prototype.updateProgressBars = function(total, pending, reviewed, accepted, rejected) {
    var progressBars = document.querySelectorAll('.progress-fill');
    
    if (progressBars.length >= 4 && total > 0) {
        // Pending applications progress
        progressBars[0].style.width = ((pending * 100) / total) + '%';
        
        // Reviewed applications progress
        progressBars[1].style.width = ((reviewed * 100) / total) + '%';
        
        // Accepted applications progress
        progressBars[2].style.width = ((accepted * 100) / total) + '%';
        
        // Rejected applications progress
        progressBars[3].style.width = ((rejected * 100) / total) + '%';
    }
};

/**
 * Set up table interactions
 */
ViewApplications.prototype.setupTableInteractions = function() {
    var self = this;
    
    // Add row selection
    document.addEventListener('click', function(e) {
        var row = e.target.closest('.seeker-row');
        if (row && !e.target.closest('.btn-action')) {
            var allRows = document.querySelectorAll('.seeker-row');
            for (var i = 0; i < allRows.length; i++) {
                allRows[i].classList.remove('selected');
                allRows[i].style.backgroundColor = '';
            }
            row.classList.add('selected');
            row.style.backgroundColor = 'rgba(37, 99, 235, 0.1)';
        }
    });
    
    // Add hover effects
    var rows = document.querySelectorAll('.seeker-row');
    for (var i = 0; i < rows.length; i++) {
        rows[i].addEventListener('mouseenter', function() {
            if (!this.classList.contains('selected')) {
                this.style.backgroundColor = 'rgba(37, 99, 235, 0.05)';
            }
        });
        
        rows[i].addEventListener('mouseleave', function() {
            if (!this.classList.contains('selected')) {
                this.style.backgroundColor = '';
            }
        });
    }
};

/**
 * Set up export functionality
 */
ViewApplications.prototype.setupExport = function() {
    var self = this;
    var exportBtn = document.getElementById('exportBtn');
    var refreshBtn = document.getElementById('refreshBtn');
    
    if (exportBtn) {
        exportBtn.addEventListener('click', function() {
            self.exportApplications();
        });
    }
    
    if (refreshBtn) {
        refreshBtn.addEventListener('click', function() {
            self.refreshData();
        });
    }
};

/**
 * Export applications data
 */
ViewApplications.prototype.exportApplications = function() {
    this.showLoading();
    var self = this;
    
    setTimeout(function() {
        self.hideLoading();
        
        var exportData = self.filteredApplications.map(function(app) {
            return {
                id: app.id,
                jobId: app.jobId,
                applicantId: app.applicantId,
                status: app.status.charAt(0).toUpperCase() + app.status.slice(1),
                hasCV: app.hasCV ? 'Yes' : 'No',
                exportDate: new Date().toISOString()
            };
        });
        
        // Create and download JSON file
        var json = JSON.stringify(exportData, null, 2);
        var blob = new Blob([json], { type: 'application/json' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'applications_export_' + new Date().toISOString().split('T')[0] + '.json';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        
        self.showToast('Applications data exported successfully', 'success');
    }, 1000);
};

/**
 * Refresh applications data
 */
ViewApplications.prototype.refreshData = function() {
    var refreshBtn = document.getElementById('refreshBtn');
    if (refreshBtn) {
        refreshBtn.querySelector('i').classList.add('fa-spin');
    }
    
    this.showLoading();
    var self = this;
    
    setTimeout(function() {
        if (refreshBtn) {
            refreshBtn.querySelector('i').classList.remove('fa-spin');
        }
        
        self.hideLoading();
        
        // Reload the page to get fresh data
        window.location.reload();
    }, 1000);
};

/**
 * Set up analytics functionality
 */
ViewApplications.prototype.setupAnalytics = function() {
    var viewAnalyticsBtn = document.getElementById('viewAnalytics');
    var analyticsCloseBtn = document.getElementById('analyticsClose');
    var analyticsModal = document.getElementById('analyticsModal');
    
    if (viewAnalyticsBtn) {
        viewAnalyticsBtn.addEventListener('click', function() {
            if (analyticsModal) {
                analyticsModal.classList.add('active');
            }
        });
    }
    
    if (analyticsCloseBtn) {
        analyticsCloseBtn.addEventListener('click', function() {
            if (analyticsModal) {
                analyticsModal.classList.remove('active');
            }
        });
    }
    
    if (analyticsModal) {
        analyticsModal.addEventListener('click', function(e) {
            if (e.target === analyticsModal) {
                analyticsModal.classList.remove('active');
            }
        });
    }
};

/**
 * Set up animations
 */
ViewApplications.prototype.setupAnimations = function() {
    // Add floating animation to page icon
    var pageIcon = document.querySelector('.page-icon');
    if (pageIcon) {
        pageIcon.style.animation = 'float 6s infinite ease-in-out';
    }
    
    // Add custom animations CSS
    var style = document.createElement('style');
    style.textContent = 
        '@keyframes ripple {' +
        '    to {' +
        '        transform: scale(4);' +
        '        opacity: 0;' +
        '    }' +
        '}' +
        '' +
        '.seeker-row {' +
        '    transition: all var(--transition-base);' +
        '}' +
        '' +
        '.stats-card:hover .stats-icon {' +
        '    animation: pulse 1s ease infinite;' +
        '}' +
        '' +
        '@keyframes pulse {' +
        '    0%, 100% { transform: scale(1); }' +
        '    50% { transform: scale(1.1); }' +
        '}' +
        '' +
        '.progress-fill {' +
        '    transition: width 0.5s ease-in-out;' +
        '}' +
        '' +
        '.search-btn:hover i {' +
        '    animation: spin 0.5s ease;' +
        '}' +
        '' +
        '@keyframes spin {' +
        '    from { transform: rotate(0deg); }' +
        '    to { transform: rotate(360deg); }' +
        '}';
    document.head.appendChild(style);
};

/**
 * Set up loading overlay
 */
ViewApplications.prototype.setupLoading = function() {
    // Create loading overlay if not exists
    var overlay = document.getElementById('loadingOverlay');
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = 'loadingOverlay';
        overlay.className = 'loading-overlay';
        overlay.innerHTML = 
            '<div class="loading-spinner">' +
            '    <i class="fas fa-cog fa-spin"></i>' +
            '    <p>Loading...</p>' +
            '</div>';
        document.body.appendChild(overlay);
    }
};

/**
 * Show loading overlay
 */
ViewApplications.prototype.showLoading = function() {
    var overlay = document.getElementById('loadingOverlay');
    if (overlay) {
        overlay.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
};

/**
 * Hide loading overlay
 */
ViewApplications.prototype.hideLoading = function() {
    var overlay = document.getElementById('loadingOverlay');
    if (overlay) {
        overlay.style.display = 'none';
        document.body.style.overflow = '';
    }
};

/**
 * Set up notifications
 */
ViewApplications.prototype.setupNotifications = function() {
    // Create toast container if not exists
    var container = document.getElementById('toastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toastContainer';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
};

/**
 * Show toast notification
 */
ViewApplications.prototype.showToast = function(message, type) {
    if (type === void 0) { type = 'info'; }
    
    var container = document.getElementById('toastContainer');
    if (!container) {
        return;
    }
    
    var toast = document.createElement('div');
    toast.className = 'toast ' + type;
    
    // Set icon based on type
    var icon = 'info-circle';
    if (type === 'success') {
        icon = 'check-circle';
    } else if (type === 'error') {
        icon = 'exclamation-circle';
    } else if (type === 'warning') {
        icon = 'exclamation-triangle';
    }
    
    toast.innerHTML = 
        '<i class="fas fa-' + icon + '"></i>' +
        '<span>' + this.escapeHtml(message) + '</span>' +
        '<button class="toast-close"><i class="fas fa-times"></i></button>';
    
    // Add animation
    toast.style.animation = 'slideInRight 0.3s ease';
    
    // Close button
    var closeBtn = toast.querySelector('.toast-close');
    var self = this;
    closeBtn.addEventListener('click', function() {
        toast.style.animation = 'slideOut 0.3s ease forwards';
        setTimeout(function() {
            if (toast.parentNode) {
                toast.remove();
            }
        }, 300);
    });
    
    // Auto remove after 5 seconds
    setTimeout(function() {
        if (toast.parentNode) {
            toast.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(function() {
                if (toast.parentNode) {
                    toast.remove();
                }
            }, 300);
        }
    }, 5000);
    
    container.appendChild(toast);
    
    // Limit number of toasts
    var toasts = container.querySelectorAll('.toast');
    if (toasts.length > 3) {
        toasts[0].remove();
    }
};

/**
 * Escape HTML special characters
 */
ViewApplications.prototype.escapeHtml = function(text) {
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
};

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    window.viewApplicationsApp = new ViewApplications();
});

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ViewApplications: ViewApplications };
}