/**
 * Manage Users Management
 * Enhanced with modern features and animations
 */

class ManageUsers {
    constructor() {
        this.currentPage = 1;
        this.rowsPerPage = 10;
        this.currentSort = { column: null, direction: 'asc' };
        this.currentTheme = localStorage.getItem('adminTheme') || 'light';
        this.init();
    }

    init() {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setup());
        } else {
            this.setup();
        }
    }

    setup() {
        this.setupTheme();
        this.setupSearch();
        this.setupSorting();
        this.setupPagination();
        this.setupActions();
        this.setupEditModal();
        this.setupAnimations();
        this.setupLoading();
        this.setupNotifications();
        this.setupFloatingElements();
        
        // Initialize stats
        setTimeout(() => this.updateStats(), 100);
        
        // Setup stat card animations
        this.setupStatCards();
        
        // Initialize visible count
        this.updateVisibleCount();
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

    setupSearch() {
        const searchBox = document.getElementById('searchBox');
        const clearSearch = document.getElementById('clearSearch');
        
        if (searchBox) {
            searchBox.addEventListener('input', (e) => {
                const filter = e.target.value.toLowerCase();
                this.filterTable(filter);
                
                if (clearSearch) {
                    clearSearch.style.display = filter.length > 0 ? 'block' : 'none';
                }
            });
        }
        
        if (clearSearch) {
            clearSearch.addEventListener('click', () => {
                if (searchBox) {
                    searchBox.value = '';
                    this.filterTable('');
                    searchBox.focus();
                    clearSearch.style.display = 'none';
                }
            });
            
            if (clearSearch) {
                clearSearch.style.display = 'none';
            }
        }
    }

    filterTable(filter) {
        const rows = document.querySelectorAll('#usersTable tbody tr.user-row');
        let visibleCount = 0;
        
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            const matches = text.includes(filter);
            row.style.display = matches ? '' : 'none';
            if (matches) visibleCount++;
        });
        
        this.updateVisibleCount();
        this.currentPage = 1;
        this.updatePagination();
    }

    setupSorting() {
        // Add sort icons to table headers
        const headers = document.querySelectorAll('#usersTable th:not(.center)');
        headers.forEach((header, index) => {
            const sortIcon = document.createElement('i');
            sortIcon.className = 'fas fa-sort sort-icon';
            sortIcon.style.cssText = 'margin-left: 8px; cursor: pointer; color: var(--text-muted);';
            sortIcon.addEventListener('click', () => {
                this.sortTable(index);
            });
            header.appendChild(sortIcon);
        });
    }

    sortTable(columnIndex) {
        const table = document.getElementById('usersTable');
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr.user-row'));
        
        // Filter out hidden rows (from search)
        const visibleRows = rows.filter(row => row.style.display !== 'none');
        
        // Determine sort direction
        let direction = 'asc';
        if (this.currentSort.column === columnIndex && this.currentSort.direction === 'asc') {
            direction = 'desc';
        }
        
        // Sort visible rows
        visibleRows.sort((a, b) => {
            let aValue = '';
            let bValue = '';
            
            if (a.cells[columnIndex]) {
                aValue = a.cells[columnIndex].textContent.toLowerCase();
            }
            if (b.cells[columnIndex]) {
                bValue = b.cells[columnIndex].textContent.toLowerCase();
            }
            
            // Special handling for numeric ID
            if (columnIndex === 0) {
                aValue = parseInt(aValue) || 0;
                bValue = parseInt(bValue) || 0;
            }
            
            if (direction === 'asc') {
                return aValue > bValue ? 1 : -1;
            } else {
                return aValue < bValue ? 1 : -1;
            }
        });
        
        // Reorder rows in DOM but keep hidden rows at the end
        visibleRows.forEach(row => tbody.appendChild(row));
        
        // Update current sort
        this.currentSort.column = columnIndex;
        this.currentSort.direction = direction;
        
        this.showToast('Table sorted', 'info');
        this.updatePagination();
    }

    setupPagination() {
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');
        
        if (prevBtn) {
            prevBtn.addEventListener('click', () => {
                if (this.currentPage > 1) {
                    this.currentPage--;
                    this.updatePagination();
                }
            });
        }
        
        if (nextBtn) {
            nextBtn.addEventListener('click', () => {
                const visibleRows = document.querySelectorAll('#usersTable tbody tr.user-row');
                let visibleCount = 0;
                visibleRows.forEach(row => {
                    if (row.style.display !== 'none') visibleCount++;
                });
                const totalPages = Math.ceil(visibleCount / this.rowsPerPage);
                
                if (this.currentPage < totalPages) {
                    this.currentPage++;
                    this.updatePagination();
                }
            });
        }
        
        this.updatePagination();
    }

    updatePagination() {
        const visibleRows = document.querySelectorAll('#usersTable tbody tr.user-row');
        let visibleCount = 0;
        visibleRows.forEach(row => {
            if (row.style.display !== 'none') visibleCount++;
        });
        
        const totalRows = visibleCount;
        const totalPages = Math.max(1, Math.ceil(totalRows / this.rowsPerPage));
        
        // Ensure current page is valid
        if (this.currentPage > totalPages) {
            this.currentPage = totalPages;
        }
        
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');
        const currentPageSpan = document.getElementById('currentPage');
        const totalPagesSpan = document.getElementById('totalPages');
        
        // Update page info
        if (totalPagesSpan) totalPagesSpan.textContent = totalPages;
        if (currentPageSpan) currentPageSpan.textContent = this.currentPage;
        
        // Update button states
        if (prevBtn) prevBtn.disabled = this.currentPage <= 1;
        if (nextBtn) nextBtn.disabled = this.currentPage >= totalPages;
        
        // Show/hide rows for current page
        let currentIndex = 0;
        visibleRows.forEach((row) => {
            if (row.style.display !== 'none') {
                const start = (this.currentPage - 1) * this.rowsPerPage;
                const end = start + this.rowsPerPage;
                row.style.display = (currentIndex >= start && currentIndex < end) ? '' : 'none';
                currentIndex++;
            } else {
                // Ensure hidden rows stay hidden
                row.style.display = 'none';
            }
        });
    }

    setupActions() {
        // Refresh button
        const refreshBtn = document.getElementById('refreshTable');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => this.refreshTable());
        }
        
        // Export button
        const exportBtn = document.getElementById('exportBtn');
        if (exportBtn) {
            exportBtn.addEventListener('click', () => this.exportData());
        }
    }

    setupEditModal() {
        // Intercept edit links for modal functionality
        const editLinks = document.querySelectorAll('.action-buttons .edit');
        editLinks.forEach(link => {
            // Store original href
            const originalHref = link.getAttribute('href');
            
            // Add click event for modal
            link.addEventListener('click', (e) => {
                e.preventDefault();
                
                // Get user data from data attributes
                const userId = link.getAttribute('data-id');
                const userName = link.getAttribute('data-name');
                
                // Get user data from the row
                const row = link.closest('tr.user-row');
                let userEmail = '';
                let userRole = '';
                let userStatus = '';
                let userPhone = '';
                
                if (row) {
                    userEmail = row.cells[2] ? row.cells[2].textContent : '';
                    
                    // Get role
                    const roleCell = row.cells[3];
                    if (roleCell) {
                        userRole = roleCell.textContent.trim().toLowerCase();
                    }
                    
                    // Get status from badge
                    const statusBadge = row.cells[4] ? row.cells[4].querySelector('.badge') : null;
                    if (statusBadge) {
                        userStatus = statusBadge.textContent.trim().toLowerCase();
                        // Remove icon text if present
                        userStatus = userStatus.replace(/active|pending|approved|suspended/gi, '').trim();
                        if (!userStatus || userStatus === '') {
                            userStatus = statusBadge.className.includes('active') ? 'active' : 
                                        statusBadge.className.includes('pending') ? 'pending' :
                                        statusBadge.className.includes('approved') ? 'approved' :
                                        statusBadge.className.includes('suspended') ? 'suspended' : 'pending';
                        }
                    }
                    
                    userPhone = row.cells[5] ? row.cells[5].textContent : 'N/A';
                    if (userPhone === 'N/A') userPhone = '';
                }
                
                // Show edit modal
                this.showEditModal({
                    id: userId,
                    name: userName,
                    email: userEmail,
                    role: userRole,
                    status: userStatus,
                    phone: userPhone,
                    originalHref: originalHref
                });
            });
        });
        
        // Intercept approve/suspend/activate links
        const actionLinks = document.querySelectorAll('.action-buttons .approve, .action-buttons .suspend, .action-buttons .activate');
        actionLinks.forEach(link => {
            // Store original href
            const originalHref = link.getAttribute('href');
            const originalOnclick = link.getAttribute('onclick');
            
            // Add click event for modal
            link.addEventListener('click', (e) => {
                e.preventDefault();
                
                const action = link.classList.contains('approve') ? 'approve' : 
                             link.classList.contains('suspend') ? 'suspend' : 'activate';
                const userId = link.getAttribute('data-id');
                const userName = link.getAttribute('data-name');
                
                this.showConfirmation(action, userId, userName, originalHref, originalOnclick);
            });
        });
    }

    showEditModal(userData) {
        // Create modal
        const modal = document.createElement('div');
        modal.className = 'modal-overlay';
        modal.style.display = 'flex';
        modal.innerHTML = `
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-icon">
                        <i class="fas fa-user-edit"></i>
                    </div>
                    <h3>Edit User #${userData.id}</h3>
                    <button class="modal-close" id="closeEditModal">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <form action="${userData.originalHref}" method="get" class="modal-form" id="editUserForm">
                    <input type="hidden" name="edit" value="${userData.id}">
                    
                    <div class="form-group">
                        <label>Name</label>
                        <input type="text" name="name" value="${userData.name}" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="${userData.email}" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone" value="${userData.phone}" placeholder="Enter phone number">
                    </div>
                    
                    <div class="form-group">
                        <label>Role</label>
                        <select name="role">
                            <option value="seeker" ${userData.role === 'seeker' ? 'selected' : ''}>Seeker</option>
                            <option value="employer" ${userData.role === 'employer' ? 'selected' : ''}>Employer</option>
                            <option value="admin" ${userData.role === 'admin' ? 'selected' : ''}>Admin</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Status</label>
                        <select name="status">
                            <option value="active" ${userData.status === 'active' ? 'selected' : ''}>Active</option>
                            <option value="pending" ${userData.status === 'pending' ? 'selected' : ''}>Pending</option>
                            <option value="approved" ${userData.status === 'approved' ? 'selected' : ''}>Approved</option>
                            <option value="suspended" ${userData.status === 'suspended' ? 'selected' : ''}>Suspended</option>
                        </select>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" id="cancelEdit">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Add event listeners
        const closeModal = () => {
            modal.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => {
                if (modal.parentNode) {
                    modal.remove();
                }
            }, 300);
        };
        
        const closeBtn = modal.querySelector('#closeEditModal');
        const cancelBtn = modal.querySelector('#cancelEdit');
        
        if (closeBtn) closeBtn.addEventListener('click', closeModal);
        if (cancelBtn) cancelBtn.addEventListener('click', closeModal);
        
        // Close on outside click
        modal.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
        });
        
        // Handle form submission
        const form = modal.querySelector('#editUserForm');
        if (form) {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                
                // Collect form data
                const formData = new FormData(form);
                const queryParams = new URLSearchParams(formData).toString();
                
                // Show loading
                this.showLoading();
                
                // Submit the form via AJAX or redirect
                setTimeout(() => {
                    this.hideLoading();
                    closeModal();
                    
                    // Redirect to the edit URL with parameters
                    window.location.href = `${userData.originalHref}&${queryParams}`;
                    // Or submit via AJAX if you prefer:
                    // this.saveUserChanges(userData.id, formData);
                }, 1000);
            });
        }
    }

    saveUserChanges(userId, formData) {
        // AJAX implementation for saving user changes
        fetch(`/admin/updateUser`, {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                this.showToast('User updated successfully!', 'success');
                // Refresh the table after 1 second
                setTimeout(() => {
                    this.refreshTable();
                }, 1000);
            } else {
                this.showToast(data.message || 'Error updating user', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            this.showToast('Error updating user', 'error');
        });
    }

    showConfirmation(action, userId, userName, originalHref, originalOnclick) {
        const actionMap = {
            'approve': { 
                title: 'Approve User', 
                message: `Are you sure you want to approve <strong>${userName}</strong>?`, 
                icon: 'check-circle', 
                color: 'success' 
            },
            'suspend': { 
                title: 'Suspend User', 
                message: `Are you sure you want to suspend <strong>${userName}</strong>?`, 
                icon: 'user-slash', 
                color: 'danger' 
            },
            'activate': { 
                title: 'Activate User', 
                message: `Are you sure you want to activate <strong>${userName}</strong>?`, 
                icon: 'user-check', 
                color: 'success' 
            }
        };
        
        const config = actionMap[action];
        
        // Create confirmation modal
        const modal = document.createElement('div');
        modal.className = 'modal-overlay';
        modal.style.display = 'flex';
        modal.innerHTML = `
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-icon" style="background: linear-gradient(135deg, var(--${config.color}), var(--${config.color}));">
                        <i class="fas fa-${config.icon}"></i>
                    </div>
                    <h3>${config.title}</h3>
                    <button class="modal-close" id="closeConfirmModal">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <p>${config.message}</p>
                    <div class="modal-info" style="margin-top: 20px;">
                        <p><i class="fas fa-info-circle"></i> This action cannot be undone.</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" id="cancelConfirm">Cancel</button>
                    <button class="btn btn-primary" id="confirmAction">Confirm</button>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Add event listeners
        const closeModal = () => {
            modal.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => {
                if (modal.parentNode) {
                    modal.remove();
                }
            }, 300);
        };
        
        const closeBtn = modal.querySelector('#closeConfirmModal');
        const cancelBtn = modal.querySelector('#cancelConfirm');
        
        if (closeBtn) closeBtn.addEventListener('click', closeModal);
        if (cancelBtn) cancelBtn.addEventListener('click', closeModal);
        
        const confirmBtn = modal.querySelector('#confirmAction');
        if (confirmBtn) {
            confirmBtn.addEventListener('click', () => {
                closeModal();
                this.showLoading();
                
                // Execute original onclick if exists (for confirm dialog)
                if (originalOnclick) {
                    // Extract the confirm message from onclick
                    const confirmMatch = originalOnclick.match(/confirm\('([^']+)'\)/);
                    if (confirmMatch) {
                        const confirmMessage = confirmMatch[1];
                        if (window.confirm(confirmMessage)) {
                            // Navigate to the original href
                            window.location.href = originalHref;
                        } else {
                            this.hideLoading();
                        }
                    } else {
                        // If no confirm in onclick, just navigate
                        window.location.href = originalHref;
                    }
                } else {
                    // Just navigate to the original href
                    setTimeout(() => {
                        this.hideLoading();
                        window.location.href = originalHref;
                    }, 1000);
                }
            });
        }
        
        // Close on outside click
        modal.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
        });
    }

    refreshTable() {
        const refreshBtn = document.getElementById('refreshTable');
        if (!refreshBtn) return;
        
        const originalHTML = refreshBtn.innerHTML;
        refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Refreshing...';
        refreshBtn.disabled = true;
        
        setTimeout(() => {
            refreshBtn.innerHTML = originalHTML;
            refreshBtn.disabled = false;
            
            // Add pulse animation to rows
            const rows = document.querySelectorAll('#usersTable tbody tr.user-row');
            rows.forEach(row => {
                row.classList.add('pulse');
                setTimeout(() => row.classList.remove('pulse'), 1000);
            });
            
            this.showToast('User list refreshed successfully', 'success');
            this.updateStats();
            this.updatePagination();
        }, 1500);
    }

    exportData() {
        this.showLoading();
        
        setTimeout(() => {
            this.hideLoading();
            this.showToast('User data exported successfully', 'success');
            
            // Create CSV data
            const headers = ['ID', 'Name', 'Email', 'Role', 'Status', 'Phone'];
            const rows = document.querySelectorAll('#usersTable tbody tr.user-row');
            const data = [headers.join(',')];
            
            rows.forEach(row => {
                const cells = [];
                for (let i = 0; i < 6; i++) {
                    let text = '';
                    if (row.cells[i]) {
                        text = row.cells[i].textContent || '';
                        if (row.cells[i].querySelector('.badge')) {
                            text = row.cells[i].querySelector('.badge').textContent;
                        }
                    }
                    cells.push(`"${text.replace(/"/g, '""')}"`);
                }
                data.push(cells.join(','));
            });
            
            // Create and download CSV file
            const blob = new Blob([data.join('\n')], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `users_${new Date().toISOString().split('T')[0]}.csv`);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(url);
        }, 2000);
    }

    updateStats() {
        const rows = document.querySelectorAll('#usersTable tbody tr.user-row');
        const stats = {
            total: rows.length,
            employers: 0,
            seekers: 0,
            admins: 0
        };
        
        rows.forEach(row => {
            const roleCell = row.cells[3];
            if (roleCell) {
                const role = roleCell.textContent.toLowerCase();
                if (role.includes('employer')) stats.employers++;
                if (role.includes('seeker')) stats.seekers++;
                if (role.includes('admin')) stats.admins++;
            }
        });
        
        // Update stat cards
        this.updateStatCard('totalUsers', stats.total);
        this.updateStatCard('totalEmployers', stats.employers);
        this.updateStatCard('totalSeekers', stats.seekers);
        this.updateStatCard('totalAdmins', stats.admins);
    }

    updateStatCard(id, value) {
        const card = document.getElementById(id);
        if (card) {
            const valueElement = card.querySelector('.stat-value');
            if (valueElement) {
                const currentValue = parseInt(valueElement.textContent) || 0;
                this.animateValue(valueElement, currentValue, value, 500);
            }
        }
    }

    animateValue(element, start, end, duration) {
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            element.textContent = Math.floor(progress * (end - start) + start);
            if (progress < 1) {
                window.requestAnimationFrame(step);
            }
        };
        window.requestAnimationFrame(step);
    }

    updateVisibleCount() {
        const visibleRows = document.querySelectorAll('#usersTable tbody tr.user-row');
        let visibleCount = 0;
        visibleRows.forEach(row => {
            if (row.style.display !== 'none') visibleCount++;
        });
        
        const visibleCountElement = document.getElementById('visibleCount');
        if (visibleCountElement) {
            visibleCountElement.textContent = visibleCount;
        }
        
        const totalCountElement = document.getElementById('totalCount');
        if (totalCountElement) {
            totalCountElement.textContent = visibleRows.length;
        }
    }

    setupStatCards() {
        const statCards = document.querySelectorAll('.stat-card');
        statCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.2}s`;
            card.classList.add('fade-in');
        });
    }

    setupAnimations() {
        // Add fade-in animation to table rows
        const rows = document.querySelectorAll('#usersTable tbody tr.user-row');
        rows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
            row.classList.add('fade-in');
        });
    }

    setupLoading() {
        let overlay = document.getElementById('loadingOverlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.id = 'loadingOverlay';
            overlay.className = 'loading-overlay';
            overlay.innerHTML = `
                <div class="loading-spinner">
                    <i class="fas fa-spinner fa-spin"></i>
                    <p>Processing...</p>
                </div>
            `;
            document.body.appendChild(overlay);
        }
        
        this.showLoading = () => {
            if (overlay) overlay.style.display = 'flex';
        };
        
        this.hideLoading = () => {
            if (overlay) overlay.style.display = 'none';
        };
    }

    setupNotifications() {
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
        
        let icon = 'info-circle';
        if (type === 'success') icon = 'check-circle';
        if (type === 'error') icon = 'exclamation-circle';
        if (type === 'warning') icon = 'exclamation-triangle';
        
        toast.innerHTML = `
            <i class="fas fa-${icon}"></i>
            <span>${message}</span>
            <button class="toast-close"><i class="fas fa-times"></i></button>
        `;
        
        toast.style.animation = 'slideInRight 0.3s ease';
        
        const closeBtn = toast.querySelector('.toast-close');
        if (closeBtn) {
            closeBtn.addEventListener('click', () => {
                toast.style.animation = 'slideOut 0.3s ease forwards';
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.remove();
                    }
                }, 300);
            });
        }
        
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
    }

    setupFloatingElements() {
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
}

// Initialize the application
document.addEventListener('DOMContentLoaded', () => {
    window.manageUsersApp = new ManageUsers();
    
    // Add custom animations CSS
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideOut {
            from {
                transform: translateY(0);
                opacity: 1;
            }
            to {
                transform: translateY(-20px);
                opacity: 0;
            }
        }
        
        .pulse {
            animation: pulse 1s ease;
        }
        
        .sort-icon:hover {
            color: var(--primary) !important;
        }
        
        .modal::-webkit-scrollbar {
            width: 8px;
        }
        
        .modal::-webkit-scrollbar-track {
            background: var(--bg-secondary);
            border-radius: var(--radius-full);
        }
        
        .modal::-webkit-scrollbar-thumb {
            background: var(--border-medium);
            border-radius: var(--radius-full);
        }
        
        .modal::-webkit-scrollbar-thumb:hover {
            background: var(--primary-light);
        }
        
        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(37, 99, 235, 0.4);
            }
            50% {
                box-shadow: 0 0 0 10px rgba(37, 99, 235, 0);
            }
        }
        
        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* Pagination fixes */
        #prevPage:disabled,
        #nextPage:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .page-btn {
            transition: all 0.3s ease;
        }
        
        .page-btn:not(:disabled):hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        
        /* Ensure table rows are properly aligned */
        #usersTable tr.user-row {
            transition: all 0.3s ease;
        }
        
        #usersTable tr.user-row.hidden {
            display: none !important;
        }
    `;
    document.head.appendChild(style);
});