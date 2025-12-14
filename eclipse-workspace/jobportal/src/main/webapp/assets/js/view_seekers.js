/**
 * View Management for Seekers and Employers
 * Enhanced with modern features and animations
 * @class ViewManager
 * @version 2.0.0
 */

/* global document, window, localStorage, console */

/**
 * Main ViewManager class
 */
class ViewManager {
    
    /**
     * Creates a new ViewManager instance
     * @constructor
     */
    constructor() {
        /** @type {string} Current theme */
        this.currentTheme = localStorage.getItem('adminTheme') || 'light';
        
        /** @type {string|null} Confirmation action href */
        this.confirmHref = null;
        
        /** @type {string} Current sort field */
        this.sortField = 'id';
        
        /** @type {string} Current sort direction */
        this.sortDirection = 'asc';
        
        /** @type {Array} All records data */
        this.allRecords = [];
        
        /** @type {Array} Filtered records data */
        this.filteredRecords = [];
        
        /** @type {string} Current status filter */
        this.statusFilter = '';
        
        /** @type {string} Current search term */
        this.searchTerm = '';
        
        /** @type {boolean} Whether this is employers page */
        this.isEmployersPage = false;
        
        /** @type {string} Page type (seekers or employers) */
        this.pageType = 'seekers';
        
        /** @type {string} Page title for display */
        this.pageTitle = 'Seekers';
        
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
        // Check if this is employers page
        this.isEmployersPage = window.isEmployersPage || false;
        this.pageType = this.isEmployersPage ? 'employers' : 'seekers';
        this.pageTitle = this.isEmployersPage ? 'Employers' : 'Seekers';
        
        this.loadRecordsData();
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
    }
    
    /**
     * Load records data from table
     * @method loadRecordsData
     * @returns {void}
     */
    loadRecordsData() {
        const rows = document.querySelectorAll('.seeker-row');
        this.allRecords = [];
        
        rows.forEach((row) => {
            const id = parseInt(row.dataset.seekerId, 10);
            const name = row.querySelector('.seeker-details strong').textContent;
            const email = row.querySelector('.email-link').textContent;
            const status = row.dataset.status;
            const created = row.dataset.created;
            
            this.allRecords.push({
                id: id,
                name: name,
                email: email,
                status: status,
                created: created,
                element: row
            });
        });
        
        this.filteredRecords = [...this.allRecords];
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
     * Set up confirmation dialogs for actions
     * @method setupConfirmations
     * @returns {void}
     */
    setupConfirmations() {
        // Handle action buttons with confirmation
        document.addEventListener('click', (e) => {
            const actionBtn = e.target.closest('[data-confirm]');
            if (actionBtn) {
                e.preventDefault();
                this.showConfirmation(actionBtn);
            }
        });
        
        // Setup confirmation modal buttons
        const cancelBtn = document.getElementById('confirmCancel');
        const okBtn = document.getElementById('confirmOk');
        const modal = document.getElementById('confirmationModal');
        
        if (cancelBtn) {
            cancelBtn.addEventListener('click', () => {
                if (modal) {
                    modal.classList.remove('active');
                }
            });
        }
        
        if (okBtn) {
            okBtn.addEventListener('click', () => {
                if (this.confirmHref) {
                    window.location.href = this.confirmHref;
                }
                if (modal) {
                    modal.classList.remove('active');
                }
            });
        }
        
        // Close modal on backdrop click
        if (modal) {
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    modal.classList.remove('active');
                }
            });
        }
    }
    
    /**
     * Show confirmation dialog
     * @method showConfirmation
     * @param {HTMLElement} button - Button element that triggered confirmation
     * @returns {void}
     */
    showConfirmation(button) {
        const action = button.getAttribute('data-confirm');
        const href = button.getAttribute('href');
        const modal = document.getElementById('confirmationModal');
        const title = document.getElementById('confirmTitle');
        const message = document.getElementById('confirmMessage');
        
        if (!modal || !title || !message || !href) {
            return;
        }
        
        this.confirmHref = href;
        
        // Get entity type for messages
        const entityType = this.isEmployersPage ? 'employer' : 'job seeker';
        const entityCapital = this.isEmployersPage ? 'Employer' : 'Seeker';
        
        // Set messages based on action
        switch (action) {
            case 'activate':
                title.textContent = `Activate ${entityCapital}`;
                message.textContent = `Are you sure you want to activate this ${entityType}? They will be able to log in and use the system.`;
                break;
            case 'suspend':
                title.textContent = `Suspend ${entityCapital}`;
                message.textContent = `Are you sure you want to suspend this ${entityType}? They will not be able to log in until reactivated.`;
                break;
            case 'approve':
                title.textContent = `Approve ${entityCapital}`;
                message.textContent = `Are you sure you want to approve this ${entityType}? They will be granted full access to system features.`;
                break;
            case 'delete':
                title.textContent = `Delete ${entityCapital}`;
                message.textContent = `Are you sure you want to delete this ${entityType}? This action cannot be undone and all their data will be permanently removed.`;
                break;
            default:
                title.textContent = 'Confirm Action';
                message.textContent = 'Are you sure you want to perform this action?';
        }
        
        modal.classList.add('active');
    }
    
    /**
     * Set up filter functionality
     * @method setupFilters
     * @returns {void}
     */
    setupFilters() {
        const statusFilter = document.getElementById('statusFilter');
        const clearFiltersBtn = document.getElementById('clearFilters');
        
        if (statusFilter) {
            // Initialize with current filter value
            this.statusFilter = statusFilter.value;
            
            statusFilter.addEventListener('change', () => {
                this.statusFilter = statusFilter.value;
                this.applyFilters();
            });
        }
        
        if (clearFiltersBtn) {
            clearFiltersBtn.addEventListener('click', () => {
                this.clearFilters();
            });
        }
    }
    
    /**
     * Set up search functionality
     * @method setupSearch
     * @returns {void}
     */
    setupSearch() {
        const searchInput = document.getElementById('searchInput');
        const searchBtn = document.getElementById('searchBtn');
        
        if (searchInput) {
            // Initialize with current search value
            this.searchTerm = searchInput.value.toLowerCase().trim();
            
            // Update search term on input
            searchInput.addEventListener('input', (e) => {
                this.searchTerm = e.target.value.toLowerCase().trim();
            });
            
            // Search on Enter key
            searchInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    this.applyFilters();
                }
            });
        }
        
        if (searchBtn) {
            searchBtn.addEventListener('click', () => {
                this.applyFilters();
            });
        }
    }
    
    /**
     * Set up table sorting
     * @method setupSorting
     * @returns {void}
     */
    setupSorting() {
        const sortButtons = document.querySelectorAll('.sort-btn');
        
        sortButtons.forEach((button) => {
            button.addEventListener('click', (e) => {
                const sortField = button.dataset.sort;
                this.toggleSort(sortField);
            });
        });
    }
    
    /**
     * Toggle sort field and direction
     * @method toggleSort
     * @param {string} field - Field to sort by
     * @returns {void}
     */
    toggleSort(field) {
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
    }
    
    /**
     * Apply sorting to filtered records
     * @method applySorting
     * @returns {void}
     */
    applySorting() {
        this.filteredRecords.sort((a, b) => {
            let valueA, valueB;
            
            switch (this.sortField) {
                case 'name':
                    valueA = a.name.toLowerCase();
                    valueB = b.name.toLowerCase();
                    break;
                case 'email':
                    valueA = a.email.toLowerCase();
                    valueB = b.email.toLowerCase();
                    break;
                case 'status':
                    valueA = a.status;
                    valueB = b.status;
                    break;
                case 'created':
                    valueA = parseInt(a.created, 10);
                    valueB = parseInt(b.created, 10);
                    break;
                case 'id':
                default:
                    valueA = a.id;
                    valueB = b.id;
                    break;
            }
            
            if (this.sortDirection === 'asc') {
                return valueA > valueB ? 1 : -1;
            } else {
                return valueA < valueB ? 1 : -1;
            }
        });
        
        this.updateTable();
    }
    
    /**
     * Update sort indicators in table header
     * @method updateSortIndicators
     * @returns {void}
     */
    updateSortIndicators() {
        const sortButtons = document.querySelectorAll('.sort-btn');
        
        sortButtons.forEach((button) => {
            const icon = button.querySelector('i');
            const field = button.dataset.sort;
            
            if (field === this.sortField) {
                icon.className = this.sortDirection === 'asc' ? 'fas fa-sort-up' : 'fas fa-sort-down';
                icon.style.color = 'var(--primary)';
            } else {
                icon.className = 'fas fa-sort';
                icon.style.color = 'var(--text-muted)';
            }
        });
    }
    
    /**
     * Apply filters and search
     * @method applyFilters
     * @returns {void}
     */
    applyFilters() {
        this.filteredRecords = this.allRecords.filter((record) => {
            // Apply status filter
            const matchesStatus = !this.statusFilter || record.status === this.statusFilter;
            
            // Apply search filter
            const matchesSearch = !this.searchTerm || 
                record.name.toLowerCase().includes(this.searchTerm) ||
                record.email.toLowerCase().includes(this.searchTerm) ||
                record.id.toString().includes(this.searchTerm);
            
            return matchesStatus && matchesSearch;
        });
        
        this.applySorting();
        this.updateStats();
        this.showToast(`Found ${this.filteredRecords.length} ${this.pageType}`, 'info');
    }
    
    /**
     * Clear all filters
     * @method clearFilters
     * @returns {void}
     */
    clearFilters() {
        const statusFilter = document.getElementById('statusFilter');
        const searchInput = document.getElementById('searchInput');
        
        if (statusFilter) {
            statusFilter.value = '';
        }
        
        if (searchInput) {
            searchInput.value = '';
        }
        
        this.statusFilter = '';
        this.searchTerm = '';
        
        this.applyFilters();
        this.showToast('Filters cleared', 'info');
    }
    
    /**
     * Update table with filtered and sorted data
     * @method updateTable
     * @returns {void}
     */
    updateTable() {
        const tbody = document.getElementById('seekersTableBody');
        if (!tbody) return;
        
        // Clear existing rows (except empty row)
        const existingRows = tbody.querySelectorAll('.seeker-row');
        existingRows.forEach(row => row.remove());
        
        if (this.filteredRecords.length === 0) {
            // Show empty state if it doesn't exist
            if (!tbody.querySelector('.empty-row')) {
                const emptyIcon = this.isEmployersPage ? 'fa-building' : 'fa-user-slash';
                const emptyTitle = this.isEmployersPage ? 'No Employers Found' : 'No Job Seekers Found';
                const emptyText = this.isEmployersPage ? 
                    'There are no employers registered in the system yet.' :
                    'There are no job seekers registered in the system yet.';
                
                const emptyRow = document.createElement('tr');
                emptyRow.className = 'empty-row fade-in';
                emptyRow.innerHTML = `
                    <td colspan="6" class="empty-state">
                        <i class="fas ${emptyIcon}"></i>
                        <h4>${emptyTitle}</h4>
                        <p>${emptyText}</p>
                    </td>
                `;
                tbody.appendChild(emptyRow);
            }
        } else {
            // Remove empty row if it exists
            const emptyRow = tbody.querySelector('.empty-row');
            if (emptyRow) {
                emptyRow.remove();
            }
            
            // Add filtered and sorted rows
            this.filteredRecords.forEach((record, index) => {
                record.element.style.order = index;
                record.element.style.animationDelay = `${index * 0.1}s`;
                record.element.classList.add('fade-in');
                tbody.appendChild(record.element);
            });
        }
    }
    
    /**
     * Update statistics display
     * @method updateStats
     * @returns {void}
     */
    updateStats() {
        const totalRecords = this.filteredRecords.length;
        const activeRecords = this.filteredRecords.filter(s => s.status === 'active').length;
        const pendingRecords = this.filteredRecords.filter(s => s.status === 'pending').length;
        const suspendedRecords = this.filteredRecords.filter(s => s.status === 'suspended').length;
        
        // Update stats cards with appropriate IDs
        const totalEl = this.isEmployersPage ? 
            document.getElementById('totalEmployers') : 
            document.getElementById('totalSeekers');
        const activeEl = this.isEmployersPage ? 
            document.getElementById('activeEmployers') : 
            document.getElementById('activeSeekers');
        const pendingEl = this.isEmployersPage ? 
            document.getElementById('pendingEmployers') : 
            document.getElementById('pendingSeekers');
        const suspendedEl = this.isEmployersPage ? 
            document.getElementById('suspendedEmployers') : 
            document.getElementById('suspendedSeekers');
        
        if (totalEl) totalEl.textContent = totalRecords;
        if (activeEl) activeEl.textContent = activeRecords;
        if (pendingEl) pendingEl.textContent = pendingRecords;
        if (suspendedEl) suspendedEl.textContent = suspendedRecords;
        
        // Update progress bars
        this.updateProgressBars(totalRecords, activeRecords, pendingRecords, suspendedRecords);
    }
    
    /**
     * Update progress bars
     * @method updateProgressBars
     * @param {number} total - Total records
     * @param {number} active - Active records
     * @param {number} pending - Pending records
     * @param {number} suspended - Suspended records
     * @returns {void}
     */
    updateProgressBars(total, active, pending, suspended) {
        const progressBars = document.querySelectorAll('.progress-fill');
        
        if (progressBars.length >= 3 && total > 0) {
            // Active records progress
            progressBars[0].style.width = `${(active * 100) / total}%`;
            
            // Pending records progress
            progressBars[1].style.width = `${(pending * 100) / total}%`;
            
            // Suspended records progress
            progressBars[2].style.width = `${(suspended * 100) / total}%`;
        }
    }
    
    /**
     * Set up table interactions
     * @method setupTableInteractions
     * @returns {void}
     */
    setupTableInteractions() {
        // Add row selection
        document.addEventListener('click', (e) => {
            const row = e.target.closest('.seeker-row');
            if (row && !e.target.closest('.btn-action')) {
                document.querySelectorAll('.seeker-row').forEach((r) => {
                    r.classList.remove('selected');
                    r.style.backgroundColor = '';
                });
                row.classList.add('selected');
                row.style.backgroundColor = 'rgba(37, 99, 235, 0.1)';
            }
        });
        
        // Add hover effects
        const rows = document.querySelectorAll('.seeker-row');
        rows.forEach((row) => {
            row.addEventListener('mouseenter', () => {
                if (!row.classList.contains('selected')) {
                    row.style.backgroundColor = 'rgba(37, 99, 235, 0.05)';
                }
            });
            
            row.addEventListener('mouseleave', () => {
                if (!row.classList.contains('selected')) {
                    row.style.backgroundColor = '';
                }
            });
        });
    }
    
    /**
     * Set up export functionality
     * @method setupExport
     * @returns {void}
     */
    setupExport() {
        const exportBtn = document.getElementById('exportBtn');
        const refreshBtn = document.getElementById('refreshBtn');
        
        if (exportBtn) {
            exportBtn.addEventListener('click', () => {
                this.exportRecords();
            });
        }
        
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => {
                this.refreshData();
            });
        }
    }
    
    /**
     * Export records data
     * @method exportRecords
     * @returns {void}
     */
    exportRecords() {
        this.showLoading();
        
        setTimeout(() => {
            this.hideLoading();
            
            const exportData = this.filteredRecords.map(record => ({
                id: record.id,
                name: record.name,
                email: record.email,
                status: record.status,
                exportDate: new Date().toISOString()
            }));
            
            // Create and download JSON file
            const json = JSON.stringify(exportData, null, 2);
            const blob = new Blob([json], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `${this.pageType}_export_${new Date().toISOString().split('T')[0]}.json`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
            
            this.showToast(`${this.pageTitle} data exported successfully`, 'success');
        }, 1000);
    }
    
    /**
     * Refresh records data
     * @method refreshData
     * @returns {void}
     */
    refreshData() {
        const refreshBtn = document.getElementById('refreshBtn');
        if (refreshBtn) {
            refreshBtn.querySelector('i').classList.add('fa-spin');
        }
        
        this.showLoading();
        
        setTimeout(() => {
            if (refreshBtn) {
                refreshBtn.querySelector('i').classList.remove('fa-spin');
            }
            
            this.hideLoading();
            
            // Reload the page to get fresh data
            window.location.reload();
        }, 1000);
    }
    
    /**
     * Set up analytics functionality
     * @method setupAnalytics
     * @returns {void}
     */
    setupAnalytics() {
        const viewAnalyticsBtn = document.getElementById('viewAnalytics');
        const analyticsCloseBtn = document.getElementById('analyticsClose');
        const analyticsModal = document.getElementById('analyticsModal');
        
        if (viewAnalyticsBtn) {
            viewAnalyticsBtn.addEventListener('click', () => {
                if (analyticsModal) {
                    analyticsModal.classList.add('active');
                }
            });
        }
        
        if (analyticsCloseBtn) {
            analyticsCloseBtn.addEventListener('click', () => {
                if (analyticsModal) {
                    analyticsModal.classList.remove('active');
                }
            });
        }
        
        if (analyticsModal) {
            analyticsModal.addEventListener('click', (e) => {
                if (e.target === analyticsModal) {
                    analyticsModal.classList.remove('active');
                }
            });
        }
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
        
        // Add ripple effect to buttons
        const buttons = document.querySelectorAll('.btn:not([disabled]), .btn-action');
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
            
            .seeker-row {
                transition: all var(--transition-base);
            }
            
            .stats-card:hover .stats-icon {
                animation: pulse 1s ease infinite;
            }
            
            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.1); }
            }
            
            .progress-fill {
                transition: width 0.5s ease-in-out;
            }
            
            .search-btn:hover i {
                animation: spin 0.5s ease;
            }
            
            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
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
                    <p>Loading...</p>
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
    window.viewManagerApp = new ViewManager();
});

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ViewManager };
}