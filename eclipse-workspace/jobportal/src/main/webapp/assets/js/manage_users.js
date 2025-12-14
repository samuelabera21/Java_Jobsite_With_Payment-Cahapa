/**
 * Manage Users Management
 * Enhanced with client-side pagination and search
 * @class ManageUsers
 * @version 1.0.0
 */

/* global document, window, localStorage, console, URLSearchParams */

/**
 * @typedef {Object} UserObject
 * @property {number} id - User ID
 * @property {string} name - User name
 * @property {string} email - User email
 * @property {string} role - User role
 * @property {string} status - User status
 * @property {string} [phone] - User phone (optional)
 */

/**
 * @typedef {Object} Filters
 * @property {string} role - Role filter
 * @property {string} status - Status filter
 */

/**
 * Main ManageUsers class
 */
class ManageUsers {
    
    /**
     * Creates a new ManageUsers instance
     * @constructor
     */
    constructor() {
        /** @type {string} Current theme */
        this.currentTheme = localStorage.getItem('adminTheme') || 'light';
        
        /** @type {string|null} Confirmation action */
        this.confirmAction = null;
        
        /** @type {string|null} Confirmation href */
        this.confirmHref = null;
        
        /** @type {number} Current page number */
        this.currentPage = 1;
        
        /** @type {number} Users per page */
        this.pageSize = 10;
        
        /** @type {UserObject[]} All users */
        this.users = [];
        
        /** @type {UserObject[]} Filtered users */
        this.filteredUsers = [];
        
        /** @type {string} Search term */
        this.searchTerm = '';
        
        /** @type {Filters} Current filters */
        this.filters = {
            role: '',
            status: ''
        };
        
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
        this.loadUsersData();
        this.setupTheme();
        this.setupConfirmations();
        this.setupPagination();
        this.setupSearch();
        this.setupFilters();
        this.setupTableInteractions();
        this.setupFormValidation();
        this.setupAnimations();
        this.setupLoading();
        this.setupNotifications();
        this.renderTable();
    }
    
    /**
     * Load users data from hidden JSON element
     * @method loadUsersData
     * @returns {void}
     */
    loadUsersData() {
        try {
            const usersData = document.getElementById('usersData');
            if (usersData) {
                this.users = JSON.parse(usersData.textContent);
                this.filteredUsers = [...this.users];
                this.updateTotalInfo();
            }
        } catch (error) {
            console.error('Error loading users data:', error);
            this.showToast('Error loading user data', 'error');
        }
    }
    
    /**
     * Update total users information
     * @method updateTotalInfo
     * @returns {void}
     */
    updateTotalInfo() {
        const totalUsers = document.getElementById('totalUsers');
        const totalInfo = document.getElementById('totalInfo');
        
        if (totalUsers) {
            totalUsers.textContent = this.users.length.toString();
        }
        
        if (totalInfo) {
            totalInfo.textContent = this.users.length.toString();
        }
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
        
        // Set messages based on action
        switch (action) {
            case 'approve':
                title.textContent = 'Approve Employer';
                message.textContent = 'Are you sure you want to approve this employer? This will grant them full access to the employer features.';
                break;
            case 'activate':
                title.textContent = 'Activate User';
                message.textContent = 'Are you sure you want to activate this user? They will be able to log in and use the system.';
                break;
            case 'suspend':
                title.textContent = 'Suspend User';
                message.textContent = 'Are you sure you want to suspend this user? They will not be able to log in until reactivated.';
                break;
            default:
                title.textContent = 'Confirm Action';
                message.textContent = 'Are you sure you want to perform this action?';
        }
        
        modal.classList.add('active');
    }
    
    /**
     * Set up pagination functionality
     * @method setupPagination
     * @returns {void}
     */
    setupPagination() {
        // Handle page navigation
        document.addEventListener('click', (e) => {
            if (e.target.closest('.page-link')) {
                e.preventDefault();
                const link = e.target.closest('.page-link');
                
                if (link.classList.contains('active') || link.classList.contains('disabled')) {
                    return;
                }
                
                const page = link.dataset.page;
                if (page) {
                    this.goToPage(parseInt(page, 10));
                } else if (link.classList.contains('prev')) {
                    this.goToPage(this.currentPage - 1);
                } else if (link.classList.contains('next')) {
                    this.goToPage(this.currentPage + 1);
                } else if (link.classList.contains('first')) {
                    this.goToPage(1);
                } else if (link.classList.contains('last')) {
                    this.goToPage(this.getTotalPages());
                }
            }
        });
        
        // Handle page jump form
        const jumpForm = document.getElementById('jumpForm');
        if (jumpForm) {
            jumpForm.addEventListener('submit', (e) => {
                e.preventDefault();
                const input = document.getElementById('jumpPage');
                const page = parseInt(input.value, 10);
                const totalPages = this.getTotalPages();
                
                if (page >= 1 && page <= totalPages) {
                    this.goToPage(page);
                } else {
                    this.showToast(`Please enter a page number between 1 and ${totalPages}`, 'error');
                    input.focus();
                }
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
        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                this.searchTerm = e.target.value.toLowerCase().trim();
                this.applyFilters();
            });
        }
    }
    
    /**
     * Set up filter functionality
     * @method setupFilters
     * @returns {void}
     */
    setupFilters() {
        // Create filter dropdowns if they don't exist
        this.createFilterDropdowns();
    }
    
    /**
     * Create filter dropdown elements
     * @method createFilterDropdowns
     * @returns {void}
     */
    createFilterDropdowns() {
        const tableHeader = document.querySelector('.table-header');
        if (!tableHeader) {
            return;
        }
        
        // Create filter container if it doesn't exist
        let filterContainer = document.querySelector('.filter-container');
        if (!filterContainer) {
            filterContainer = document.createElement('div');
            filterContainer.className = 'filter-container';
            tableHeader.appendChild(filterContainer);
        }
        
        // Role filter
        const roleFilter = document.createElement('select');
        roleFilter.className = 'form-control form-select filter-select';
        roleFilter.innerHTML = `
            <option value="">All Roles</option>
            <option value="seeker">Job Seeker</option>
            <option value="employer">Employer</option>
            <option value="admin">Administrator</option>
        `;
        roleFilter.value = this.filters.role;
        
        // Status filter
        const statusFilter = document.createElement('select');
        statusFilter.className = 'form-control form-select filter-select';
        statusFilter.innerHTML = `
            <option value="">All Status</option>
            <option value="active">Active</option>
            <option value="pending">Pending</option>
            <option value="approved">Approved</option>
            <option value="suspended">Suspended</option>
        `;
        statusFilter.value = this.filters.status;
        
        // Clear filters button
        const clearButton = document.createElement('button');
        clearButton.type = 'button';
        clearButton.className = 'btn btn-secondary btn-sm';
        clearButton.innerHTML = '<i class="fas fa-times"></i> Clear Filters';
        clearButton.style.marginLeft = 'auto';
        
        filterContainer.innerHTML = '';
        filterContainer.appendChild(roleFilter);
        filterContainer.appendChild(statusFilter);
        filterContainer.appendChild(clearButton);
        
        // Add event listeners
        roleFilter.addEventListener('change', () => {
            this.filters.role = roleFilter.value;
            this.applyFilters();
        });
        
        statusFilter.addEventListener('change', () => {
            this.filters.status = statusFilter.value;
            this.applyFilters();
        });
        
        clearButton.addEventListener('click', () => {
            roleFilter.value = '';
            statusFilter.value = '';
            this.filters.role = '';
            this.filters.status = '';
            this.applyFilters();
        });
    }
    
    /**
     * Apply search and filter criteria
     * @method applyFilters
     * @returns {void}
     */
    applyFilters() {
        this.filteredUsers = this.users.filter((user) => {
            // Apply search filter
            const matchesSearch = !this.searchTerm || 
                user.name.toLowerCase().includes(this.searchTerm) ||
                user.email.toLowerCase().includes(this.searchTerm) ||
                (user.phone && user.phone.toLowerCase().includes(this.searchTerm)) ||
                user.role.toLowerCase().includes(this.searchTerm) ||
                user.status.toLowerCase().includes(this.searchTerm);
            
            // Apply role filter
            const matchesRole = !this.filters.role || user.role === this.filters.role;
            
            // Apply status filter
            const matchesStatus = !this.filters.status || user.status === this.filters.status;
            
            return matchesSearch && matchesRole && matchesStatus;
        });
        
        // Reset to first page when filters change
        this.currentPage = 1;
        this.renderTable();
    }
    
    /**
     * Get total number of pages
     * @method getTotalPages
     * @returns {number} Total pages
     */
    getTotalPages() {
        return Math.ceil(this.filteredUsers.length / this.pageSize);
    }
    
    /**
     * Get users for current page
     * @method getCurrentPageUsers
     * @returns {UserObject[]} Users for current page
     */
    getCurrentPageUsers() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        return this.filteredUsers.slice(start, end);
    }
    
    /**
     * Navigate to specific page
     * @method goToPage
     * @param {number} page - Page number
     * @returns {void}
     */
    goToPage(page) {
        const totalPages = this.getTotalPages();
        
        if (page < 1 || page > totalPages) {
            return;
        }
        
        this.currentPage = page;
        this.renderTable();
        
        // Scroll to top of table
        const table = document.querySelector('.table-container');
        if (table) {
            table.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }
    
    /**
     * Render users table
     * @method renderTable
     * @returns {void}
     */
    renderTable() {
        const tbody = document.getElementById('usersTableBody');
        if (!tbody) {
            return;
        }
        
        const currentUsers = this.getCurrentPageUsers();
        const totalPages = this.getTotalPages();
        const totalUsers = this.filteredUsers.length;
        
        // Clear existing rows
        tbody.innerHTML = '';
        
        // Render users
        if (currentUsers.length === 0) {
            this.renderEmptyState();
        } else {
            currentUsers.forEach((user, index) => {
                const row = this.createUserRow(user, index);
                tbody.appendChild(row);
            });
        }
        
        // Update pagination info
        this.updatePaginationInfo(totalUsers);
        
        // Render pagination controls
        this.renderPagination(totalPages);
    }
    
    /**
     * Create a user table row
     * @method createUserRow
     * @param {UserObject} user - User object
     * @param {number} index - Row index
     * @returns {HTMLTableRowElement} Table row element
     */
    createUserRow(user, index) {
        const row = document.createElement('tr');
        row.className = 'user-row fade-in';
        row.dataset.userId = user.id.toString();
        row.style.animationDelay = `${index * 0.1}s`;
        
        // Get icons based on role and status
        const roleIcon = this.getRoleIcon(user.role);
        const statusIcon = this.getStatusIcon(user.status);
        
        row.innerHTML = `
            <td class="user-id">${user.id}</td>
            <td class="user-name">${this.escapeHtml(user.name)}</td>
            <td class="user-email">${this.escapeHtml(user.email)}</td>
            <td class="user-role">
                <span class="role-badge ${user.role}">
                    <i class="fas ${roleIcon}"></i>
                    ${this.capitalizeFirst(user.role)}
                </span>
            </td>
            <td class="user-status">
                <span class="status-badge ${user.status}">
                    <i class="fas ${statusIcon}"></i>
                    ${this.capitalizeFirst(user.status)}
                </span>
            </td>
            <td class="user-phone">${user.phone ? this.escapeHtml(user.phone) : 'N/A'}</td>
            <td class="user-actions">
                <!-- Edit -->
                <a href="?edit=${user.id}" class="btn-action btn-edit" 
                   data-tooltip="Edit User">
                    <i class="fas fa-edit"></i>
                </a>

                <!-- Dynamic Actions -->
                ${this.getActionButtons(user)}
            </td>
        `;
        
        return row;
    }
    
    /**
     * Get icon for user role
     * @method getRoleIcon
     * @param {string} role - User role
     * @returns {string} Icon class
     */
    getRoleIcon(role) {
        switch (role) {
            case 'seeker': 
                return 'fa-search';
            case 'employer': 
                return 'fa-building';
            case 'admin': 
                return 'fa-crown';
            default: 
                return 'fa-user';
        }
    }
    
    /**
     * Get icon for user status
     * @method getStatusIcon
     * @param {string} status - User status
     * @returns {string} Icon class
     */
    getStatusIcon(status) {
        switch (status) {
            case 'active': 
                return 'fa-check-circle';
            case 'pending': 
                return 'fa-clock';
            case 'approved': 
                return 'fa-user-check';
            case 'suspended': 
                return 'fa-ban';
            default: 
                return 'fa-circle';
        }
    }
    
    /**
     * Get action buttons HTML for a user
     * @method getActionButtons
     * @param {UserObject} user - User object
     * @returns {string} Action buttons HTML
     */
    getActionButtons(user) {
        const contextPath = window.location.pathname.split('/admin')[0];
        
        if (user.role === 'employer' && user.status === 'pending') {
            return `
                <a href="${contextPath}/admin/approveEmployer?id=${user.id}"
                   class="btn-action btn-approve"
                   data-tooltip="Approve Employer"
                   data-confirm="approve">
                    <i class="fas fa-check"></i>
                </a>
            `;
        } else {
            if (user.status === 'approved' || user.status === 'active') {
                return `
                    <a href="${contextPath}/admin/deactivateUser?id=${user.id}"
                       class="btn-action btn-suspend"
                       data-tooltip="Suspend User"
                       data-confirm="suspend">
                        <i class="fas fa-ban"></i>
                    </a>
                `;
            } else {
                return `
                    <a href="${contextPath}/admin/activateUser?id=${user.id}"
                       class="btn-action btn-activate"
                       data-tooltip="Activate User"
                       data-confirm="activate">
                        <i class="fas fa-play"></i>
                    </a>
                `;
            }
        }
    }
    
    /**
     * Render empty state when no users found
     * @method renderEmptyState
     * @returns {void}
     */
    renderEmptyState() {
        const tbody = document.getElementById('usersTableBody');
        tbody.innerHTML = `
            <tr class="empty-row fade-in">
                <td colspan="7" class="empty-state">
                    <i class="fas fa-user-slash"></i>
                    <h4>No Users Found</h4>
                    <p>${this.searchTerm || this.filters.role || this.filters.status 
                        ? 'No users match your search criteria. Try adjusting your filters.' 
                        : 'There are no users to display.'}</p>
                    ${this.searchTerm || this.filters.role || this.filters.status ? 
                        '<button class="btn btn-secondary btn-sm" id="clearAllFilters">Clear All Filters</button>' : ''}
                </td>
            </tr>
        `;
        
        // Add event listener for clear all filters button
        const clearButton = document.getElementById('clearAllFilters');
        if (clearButton) {
            clearButton.addEventListener('click', () => {
                this.clearAllFilters();
            });
        }
    }
    
    /**
     * Clear all filters and search
     * @method clearAllFilters
     * @returns {void}
     */
    clearAllFilters() {
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.value = '';
        }
        this.searchTerm = '';
        this.filters.role = '';
        this.filters.status = '';
        this.createFilterDropdowns();
        this.applyFilters();
    }
    
    /**
     * Update pagination information display
     * @method updatePaginationInfo
     * @param {number} totalUsers - Total filtered users
     * @returns {void}
     */
    updatePaginationInfo(totalUsers) {
        const currentPageEl = document.getElementById('currentPage');
        const totalPagesEl = document.getElementById('totalPages');
        const showingRangeEl = document.getElementById('showingRange');
        const showingInfoEl = document.getElementById('showingInfo');
        const jumpInput = document.getElementById('jumpPage');
        
        const totalPages = this.getTotalPages();
        const start = (this.currentPage - 1) * this.pageSize + 1;
        const end = Math.min(start + this.pageSize - 1, totalUsers);
        
        if (currentPageEl) {
            currentPageEl.textContent = this.currentPage.toString();
        }
        if (totalPagesEl) {
            totalPagesEl.textContent = totalPages.toString();
        }
        if (showingRangeEl) {
            showingRangeEl.textContent = `${start}-${end}`;
        }
        if (showingInfoEl) {
            showingInfoEl.textContent = `${start}-${end}`;
        }
        if (jumpInput) {
            jumpInput.value = this.currentPage.toString();
            jumpInput.max = totalPages.toString();
        }
    }
    
    /**
     * Render pagination controls
     * @method renderPagination
     * @param {number} totalPages - Total number of pages
     * @returns {void}
     */
    renderPagination(totalPages) {
        const pageLinks = document.getElementById('pageLinks');
        const paginationContainer = document.getElementById('paginationContainer');
        const paginationControls = document.getElementById('paginationControls');
        
        if (!pageLinks || !paginationContainer) {
            return;
        }
        
        // Hide pagination if no pages
        if (totalPages <= 1) {
            paginationContainer.classList.add('hidden');
            if (paginationControls) {
                paginationControls.innerHTML = '';
            }
            return;
        }
        
        paginationContainer.classList.remove('hidden');
        
        // Create page links
        let links = '';
        
        // First and previous buttons
        if (this.currentPage > 1) {
            links += `
                <a href="#" class="page-link first" data-page="1" title="First Page">
                    <i class="fas fa-angle-double-left"></i>
                </a>
                <a href="#" class="page-link prev" data-page="${this.currentPage - 1}" title="Previous Page">
                    <i class="fas fa-angle-left"></i>
                </a>
            `;
        } else {
            links += `
                <span class="page-link first disabled">
                    <i class="fas fa-angle-double-left"></i>
                </span>
                <span class="page-link prev disabled">
                    <i class="fas fa-angle-left"></i>
                </span>
            `;
        }
        
        // Page numbers
        const maxVisible = 5;
        let startPage = Math.max(1, this.currentPage - Math.floor(maxVisible / 2));
        let endPage = Math.min(totalPages, startPage + maxVisible - 1);
        
        // Adjust if we're near the beginning
        if (endPage - startPage + 1 < maxVisible) {
            startPage = Math.max(1, endPage - maxVisible + 1);
        }
        
        for (let i = startPage; i <= endPage; i++) {
            links += `
                <a href="#" class="page-link ${i === this.currentPage ? 'active' : ''}" 
                   data-page="${i}" ${i === this.currentPage ? 'aria-current="page"' : ''}>
                    ${i}
                </a>
            `;
        }
        
        // Next and last buttons
        if (this.currentPage < totalPages) {
            links += `
                <a href="#" class="page-link next" data-page="${this.currentPage + 1}" title="Next Page">
                    <i class="fas fa-angle-right"></i>
                </a>
                <a href="#" class="page-link last" data-page="${totalPages}" title="Last Page">
                    <i class="fas fa-angle-double-right"></i>
                </a>
            `;
        } else {
            links += `
                <span class="page-link next disabled">
                    <i class="fas fa-angle-right"></i>
                </span>
                <span class="page-link last disabled">
                    <i class="fas fa-angle-double-right"></i>
                </span>
            `;
        }
        
        pageLinks.innerHTML = links;
        
        // Update pagination controls
        if (paginationControls) {
            let controls = '';
            
            if (this.currentPage > 1) {
                controls += `
                    <a href="#" class="btn btn-secondary btn-sm page-link prev">
                        <i class="fas fa-chevron-left"></i>
                        Previous
                    </a>
                `;
            }
            
            if (this.currentPage < totalPages) {
                controls += `
                    <a href="#" class="btn btn-secondary btn-sm page-link next">
                        Next
                        <i class="fas fa-chevron-right"></i>
                    </a>
                `;
            }
            
            paginationControls.innerHTML = controls;
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
    
    /**
     * Capitalize first letter of string
     * @method capitalizeFirst
     * @param {string} string - String to capitalize
     * @returns {string} Capitalized string
     */
    capitalizeFirst(string) {
        if (!string) {
            return '';
        }
        return string.charAt(0).toUpperCase() + string.slice(1);
    }
    
    /**
     * Set up table interactions
     * @method setupTableInteractions
     * @returns {void}
     */
    setupTableInteractions() {
        // Add row selection
        document.addEventListener('click', (e) => {
            const row = e.target.closest('.user-row');
            if (row && !e.target.closest('.btn-action')) {
                document.querySelectorAll('.user-row').forEach((r) => {
                    r.classList.remove('selected');
                    r.style.backgroundColor = '';
                });
                row.classList.add('selected');
                row.style.backgroundColor = 'rgba(37, 99, 235, 0.1)';
            }
        });
    }
    
    /**
     * Set up form validation
     * @method setupFormValidation
     * @returns {void}
     */
    setupFormValidation() {
        const form = document.querySelector('.user-form');
        if (!form) {
            return;
        }
        
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            
            // Validate form
            const inputs = form.querySelectorAll('input[required], select[required]');
            let isValid = true;
            
            inputs.forEach((input) => {
                if (!input.value.trim()) {
                    input.classList.add('error');
                    isValid = false;
                } else {
                    input.classList.remove('error');
                }
            });
            
            // Email validation
            const emailInput = form.querySelector('input[type="email"]');
            if (emailInput && emailInput.value) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(emailInput.value)) {
                    emailInput.classList.add('error');
                    isValid = false;
                    this.showToast('Please enter a valid email address', 'error');
                }
            }
            
            if (!isValid) {
                this.showToast('Please fill in all required fields', 'error');
                return;
            }
            
            // Show loading and submit
            this.showLoading();
            
            // Simulate loading
            setTimeout(() => {
                this.hideLoading();
                form.submit();
            }, 1000);
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
        
        // Add ripple effect to buttons
        const addRipple = (element) => {
            element.addEventListener('click', (e) => {
                const ripple = document.createElement('span');
                const rect = element.getBoundingClientRect();
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
                
                element.appendChild(ripple);
                setTimeout(() => {
                    if (ripple.parentNode) {
                        ripple.remove();
                    }
                }, 600);
            });
        };
        
        // Add custom animations CSS
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
            
            @keyframes slideIn {
                from {
                    transform: translateY(20px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            
            .fade-in {
                animation: slideIn 0.3s ease forwards;
                opacity: 0;
            }
            
            .page-link.active {
                animation: pulse 2s infinite;
            }
            
            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.05); }
            }
            
            .disabled {
                opacity: 0.5;
                cursor: not-allowed;
                pointer-events: none;
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
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.manageUsersApp = new ManageUsers();
});

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ManageUsers };
}