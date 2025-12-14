/**
 * Pending Employers Management
 * Enhanced with modern features and animations
 */

class PendingEmployers {
    constructor() {
        this.currentPage = 1;
        this.rowsPerPage = 10;
        this.currentSort = { column: null, direction: 'asc' };
        this.chartInstance = null;
        this.init();
    }

    init() {
        // Initialize when DOM is loaded
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setup());
        } else {
            this.setup();
        }
    }

    setup() {
        // Setup all features
        this.setupTheme();
        this.setupSearch();
        this.setupFilters();
        this.setupSorting();
        this.setupPagination();
        this.setupActions();
        this.setupModals();
        this.setupCharts();
        this.setupQuickActions();
        this.setupAnimations();
        this.setupLoading();
        this.setupNotifications();
        
        // Initialize chart with data from JSP
        setTimeout(() => {
            this.updateChartData();
        }, 100);
    }

    setupTheme() {
        const themeToggle = document.getElementById('themeToggle');
        
        // Check saved theme
        const savedTheme = localStorage.getItem('adminTheme');
        if (savedTheme === 'dark') {
            document.body.classList.add('dark');
            this.updateThemeButton('light');
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
            this.updateThemeButton('dark');
            this.showToast('Light mode enabled', 'info');
        } else {
            body.classList.add('dark');
            localStorage.setItem('adminTheme', 'dark');
            this.updateThemeButton('light');
            this.showToast('Dark mode enabled', 'info');
        }
    }

    updateThemeButton(targetTheme) {
        const themeToggle = document.getElementById('themeToggle');
        if (!themeToggle) return;
        
        if (targetTheme === 'light') {
            themeToggle.innerHTML = '<i class="fas fa-sun"></i><span>Light Mode</span>';
            themeToggle.classList.remove('dark-mode');
            themeToggle.classList.add('light-mode');
        } else {
            themeToggle.innerHTML = '<i class="fas fa-moon"></i><span>Dark Mode</span>';
            themeToggle.classList.remove('light-mode');
            themeToggle.classList.add('dark-mode');
        }
    }

    setupSearch() {
        const searchBox = document.getElementById('searchBox');
        const clearSearch = document.getElementById('clearSearch');
        
        if (searchBox) {
            // Use debouncing for better performance
            const debouncedSearch = this.debounce((filter) => {
                this.filterTable(filter);
            }, 300);
            
            searchBox.addEventListener('input', (e) => {
                const filter = e.target.value.toLowerCase();
                debouncedSearch(filter);
                
                // Show/hide clear button
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
            
            // Hide initially
            clearSearch.style.display = 'none';
        }
    }

    filterTable(filter) {
        const rows = document.querySelectorAll('#empTable tbody tr.employer-row');
        let visibleCount = 0;
        
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            const matches = text.includes(filter);
            row.style.display = matches ? '' : 'none';
            if (matches) visibleCount++;
        });
        
        // Update visible count
        this.updateVisibleCount();
        
        // Show/hide no data message
        this.updateNoDataMessage(visibleCount);
        
        // Reset to first page
        this.currentPage = 1;
        
        // Update pagination
        this.updatePagination();
        
        // Update total count
        const totalCountElement = document.getElementById('totalCount');
        if (totalCountElement) {
            const allRows = document.querySelectorAll('#empTable tbody tr.employer-row').length;
            totalCountElement.textContent = allRows;
        }
    }

    setupFilters() {
        const filterButtons = document.querySelectorAll('.filter-btn');
        
        filterButtons.forEach(button => {
            button.addEventListener('click', () => {
                // Remove active class from all buttons
                filterButtons.forEach(btn => btn.classList.remove('active'));
                
                // Add active class to clicked button
                button.classList.add('active');
                
                // Apply filter
                const filter = button.dataset.filter;
                this.applyFilter(filter);
            });
        });
    }

    applyFilter(filter) {
        const rows = document.querySelectorAll('#empTable tbody tr.employer-row');
        
        rows.forEach((row, index) => {
            switch(filter) {
                case 'all':
                    row.style.display = '';
                    break;
                case 'recent':
                    // Show first 5 as "recent"
                    row.style.display = index < 5 ? '' : 'none';
                    break;
                case 'pending':
                    // All are pending in this view
                    row.style.display = '';
                    break;
            }
        });
        
        // Reset to first page
        this.currentPage = 1;
        
        this.updateVisibleCount();
        this.updatePagination();
    }

    setupSorting() {
        const sortIcons = document.querySelectorAll('.sort-icon');
        
        sortIcons.forEach(icon => {
            icon.addEventListener('click', () => {
                const column = icon.dataset.sort;
                this.sortTable(column);
            });
        });
    }

    sortTable(column) {
        const table = document.getElementById('empTable');
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr.employer-row'));
        
        // Determine sort direction
        let direction = 'asc';
        if (this.currentSort.column === column && this.currentSort.direction === 'asc') {
            direction = 'desc';
        }
        
        // Sort rows
        rows.sort((a, b) => {
            let aValue, bValue;
            
            switch(column) {
                case 'id':
                    const aIdBadge = a.querySelector('.id-badge');
                    const bIdBadge = b.querySelector('.id-badge');
                    aValue = aIdBadge ? parseInt(aIdBadge.textContent.replace('#', '')) : 0;
                    bValue = bIdBadge ? parseInt(bIdBadge.textContent.replace('#', '')) : 0;
                    break;
                case 'name':
                    const aName = a.querySelector('.employer-details h4');
                    const bName = b.querySelector('.employer-details h4');
                    aValue = aName ? aName.textContent.toLowerCase() : '';
                    bValue = bName ? bName.textContent.toLowerCase() : '';
                    break;
                case 'email':
                    const aEmail = a.querySelector('.contact-item:first-child span');
                    const bEmail = b.querySelector('.contact-item:first-child span');
                    aValue = aEmail ? aEmail.textContent.toLowerCase() : '';
                    bValue = bEmail ? bEmail.textContent.toLowerCase() : '';
                    break;
                case 'date':
                    const aDate = a.querySelector('.date-info span');
                    const bDate = b.querySelector('.date-info span');
                    aValue = aDate ? aDate.textContent : '';
                    bValue = bDate ? bDate.textContent : '';
                    break;
                default:
                    aValue = a.cells[0] ? a.cells[0].textContent : '';
                    bValue = b.cells[0] ? b.cells[0].textContent : '';
            }
            
            if (direction === 'asc') {
                return aValue > bValue ? 1 : -1;
            } else {
                return aValue < bValue ? 1 : -1;
            }
        });
        
        // Reorder rows in DOM
        rows.forEach(row => tbody.appendChild(row));
        
        // Update sort icons
        this.updateSortIcons(column, direction);
        
        // Update current sort
        this.currentSort.column = column;
        this.currentSort.direction = direction;
        
        this.showToast(`Sorted by ${column} (${direction})`, 'info');
    }

    updateSortIcons(column, direction) {
        const icons = document.querySelectorAll('.sort-icon');
        icons.forEach(icon => {
            icon.className = 'fas fa-sort sort-icon';
            if (icon.dataset.sort === column) {
                icon.className = direction === 'asc' 
                    ? 'fas fa-sort-up sort-icon' 
                    : 'fas fa-sort-down sort-icon';
            }
        });
    }

    setupPagination() {
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');
        const currentPageSpan = document.getElementById('currentPage');
        const totalPagesSpan = document.getElementById('totalPages');
        
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
                const visibleRows = document.querySelectorAll('#empTable tbody tr.employer-row[style*="display: """]').length;
                const totalPages = Math.ceil(visibleRows / this.rowsPerPage);
                
                if (this.currentPage < totalPages) {
                    this.currentPage++;
                    this.updatePagination();
                }
            });
        }
        
        // Initial update
        this.updatePagination();
    }

    updatePagination() {
        const visibleRows = document.querySelectorAll('#empTable tbody tr.employer-row[style*="display: """]');
        const totalRows = visibleRows.length;
        const totalPages = Math.ceil(totalRows / this.rowsPerPage);
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');
        const currentPageSpan = document.getElementById('currentPage');
        const totalPagesSpan = document.getElementById('totalPages');
        const visibleCountElement = document.getElementById('visibleCount');
        
        // Ensure current page is valid
        if (this.currentPage > totalPages && totalPages > 0) {
            this.currentPage = totalPages;
        } else if (totalPages === 0) {
            this.currentPage = 1;
        }
        
        // Update page info
        if (totalPagesSpan) totalPagesSpan.textContent = totalPages || 1;
        if (currentPageSpan) currentPageSpan.textContent = this.currentPage;
        
        // Update button states
        if (prevBtn) prevBtn.disabled = this.currentPage === 1;
        if (nextBtn) nextBtn.disabled = this.currentPage === totalPages || totalPages === 0;
        
        // Show/hide rows for current page
        visibleRows.forEach((row, index) => {
            const start = (this.currentPage - 1) * this.rowsPerPage;
            const end = start + this.rowsPerPage;
            row.style.display = (index >= start && index < end) ? '' : 'none';
        });
        
        // Update visible count
        const visibleCount = totalRows > 0 ? Math.min(this.rowsPerPage, totalRows - (this.currentPage - 1) * this.rowsPerPage) : 0;
        if (visibleCountElement) {
            visibleCountElement.textContent = visibleCount;
        }
    }

    setupActions() {
        // Approve buttons
        const approveButtons = document.querySelectorAll('.btn-approve');
        approveButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                const id = button.dataset.id;
                const name = button.dataset.name;
                this.showApprovalModal(id, name, button.href);
            });
        });
        
        // View buttons
        const viewButtons = document.querySelectorAll('.btn-view');
        viewButtons.forEach(button => {
            button.addEventListener('click', () => {
                const id = button.dataset.id;
                this.viewEmployer(id);
            });
        });
        
        // Reject buttons
        const rejectButtons = document.querySelectorAll('.btn-reject');
        rejectButtons.forEach(button => {
            button.addEventListener('click', () => {
                const id = button.dataset.id;
                this.rejectEmployer(id);
            });
        });
        
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

    showApprovalModal(id, name, href) {
        const modal = document.getElementById('approvalModal');
        const nameSpan = document.getElementById('modalEmployerName');
        const confirmLink = document.getElementById('confirmApprove');
        
        if (!modal || !nameSpan || !confirmLink) return;
        
        nameSpan.textContent = name;
        confirmLink.href = href;
        
        modal.style.display = 'flex';
        
        // Add animation
        const modalContent = modal.querySelector('.modal');
        if (modalContent) {
            modalContent.style.animation = 'slideIn 0.3s ease';
        }
        
        // Prevent background scroll
        document.body.style.overflow = 'hidden';
    }

    hideApprovalModal() {
        const modal = document.getElementById('approvalModal');
        if (modal) {
            const modalContent = modal.querySelector('.modal');
            if (modalContent) {
                modalContent.style.animation = 'slideOut 0.3s ease';
            }
            setTimeout(() => {
                modal.style.display = 'none';
                // Restore background scroll
                document.body.style.overflow = 'auto';
            }, 300);
        }
    }

    viewEmployer(id) {
        this.showLoading();
        // Simulate API call or redirect to view page
        setTimeout(() => {
            this.hideLoading();
            this.showToast(`Viewing employer #${id} details`, 'info');
            // In a real application, you might redirect to a view page
            // window.location.href = `/admin/viewEmployer?id=${id}`;
        }, 1000);
    }

    rejectEmployer(id) {
        if (confirm('Are you sure you want to reject this employer?')) {
            this.showLoading();
            
            // In a real application, make an AJAX call here
            // fetch(`/admin/rejectEmployer?id=${id}`, { method: 'POST' })
            
            setTimeout(() => {
                this.hideLoading();
                this.showToast(`Employer #${id} rejected successfully`, 'success');
                
                // Remove row from table
                const row = document.querySelector(`.btn-reject[data-id="${id}"]`);
                if (row) {
                    const tableRow = row.closest('tr');
                    if (tableRow) {
                        tableRow.style.animation = 'slideOut 0.3s ease';
                        setTimeout(() => {
                            tableRow.remove();
                            this.updateVisibleCount();
                            this.updatePagination();
                            this.updateChartData();
                        }, 300);
                    }
                }
            }, 1500);
        }
    }

    refreshTable() {
        const refreshBtn = document.getElementById('refreshTable');
        if (!refreshBtn) return;
        
        const originalHTML = refreshBtn.innerHTML;
        const originalText = refreshBtn.textContent;
        
        refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Refreshing...';
        refreshBtn.disabled = true;
        
        // Simulate refresh - in real app, fetch new data
        setTimeout(() => {
            refreshBtn.innerHTML = originalHTML;
            refreshBtn.disabled = false;
            
            // Add pulse animation to rows
            const rows = document.querySelectorAll('#empTable tbody tr.employer-row');
            rows.forEach(row => {
                row.classList.add('pulse');
                setTimeout(() => row.classList.remove('pulse'), 1000);
            });
            
            this.showToast('Table refreshed successfully', 'success');
            this.updateChartData();
        }, 1500);
    }

    exportData() {
        this.showLoading();
        
        // Simulate export process
        setTimeout(() => {
            this.hideLoading();
            this.showToast('Data exported successfully. Download will start shortly.', 'success');
            
            // Create CSV data
            const data = this.getExportData();
            const blob = new Blob([data], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `pending_employers_${new Date().toISOString().split('T')[0]}.csv`);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }, 2000);
    }

    getExportData() {
        const headers = ['ID', 'Name', 'Email', 'Phone', 'Company', 'Status', 'Registration Date'];
        const rows = document.querySelectorAll('#empTable tbody tr.employer-row');
        const data = [headers.join(',')];
        
        rows.forEach(row => {
            if (row.style.display !== 'none') {
                const idBadge = row.querySelector('.id-badge');
                const name = row.querySelector('.employer-details h4');
                const email = row.querySelector('.contact-item:first-child span');
                const phone = row.querySelector('.contact-item:nth-child(2) span');
                const company = row.querySelector('.company-info span');
                const date = row.querySelector('.date-info span');
                
                const cells = [
                    idBadge ? idBadge.textContent.replace('#', '') : '',
                    name ? this.escapeCSV(name.textContent) : '',
                    email ? this.escapeCSV(email.textContent) : '',
                    phone ? this.escapeCSV(phone.textContent) : '',
                    company ? this.escapeCSV(company.textContent) : '',
                    'Pending Approval',
                    date ? this.escapeCSV(date.textContent) : ''
                ];
                data.push(cells.join(','));
            }
        });
        
        return data.join('\n');
    }

    escapeCSV(text) {
        if (text.includes(',') || text.includes('"') || text.includes('\n')) {
            return '"' + text.replace(/"/g, '""') + '"';
        }
        return text;
    }

    setupModals() {
        const modal = document.getElementById('approvalModal');
        const closeModal = document.getElementById('closeModal');
        const cancelApprove = document.getElementById('cancelApprove');
        const confirmApprove = document.getElementById('confirmApprove');
        
        if (closeModal) {
            closeModal.addEventListener('click', () => this.hideApprovalModal());
        }
        
        if (cancelApprove) {
            cancelApprove.addEventListener('click', () => this.hideApprovalModal());
        }
        
        if (confirmApprove) {
            confirmApprove.addEventListener('click', (e) => {
                e.preventDefault();
                this.hideApprovalModal();
                this.showLoading();
                
                // Show success message before redirecting
                setTimeout(() => {
                    this.hideLoading();
                    this.showToast('Employer approved successfully', 'success');
                    
                    // Navigate to approval URL after a short delay
                    setTimeout(() => {
                        window.location.href = confirmApprove.href;
                    }, 500);
                }, 1000);
            });
        }
        
        // Close modal when clicking outside
        if (modal) {
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    this.hideApprovalModal();
                }
            });
        }
    }

    setupCharts() {
        this.updateChartData();
    }

    updateChartData() {
        const ctx = document.getElementById('approvalChart');
        if (!ctx) return;
        
        // Get pending count
        const pendingCount = document.querySelectorAll('#empTable tbody tr.employer-row').length;
        
        // Destroy existing chart if any
        if (this.chartInstance) {
            this.chartInstance.destroy();
        }
        
        this.chartInstance = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Pending', 'Approved', 'Rejected'],
                datasets: [{
                    data: [pendingCount, 0, 0],
                    backgroundColor: [
                        'rgba(245, 158, 11, 0.8)',
                        'rgba(16, 185, 129, 0.8)',
                        'rgba(239, 68, 68, 0.8)'
                    ],
                    borderColor: [
                        'rgb(245, 158, 11)',
                        'rgb(16, 185, 129)',
                        'rgb(239, 68, 68)'
                    ],
                    borderWidth: 1,
                    hoverOffset: 15
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return `${context.label}: ${context.raw}`;
                            }
                        }
                    }
                },
                animation: {
                    animateScale: true,
                    animateRotate: true
                }
            }
        });
    }

    setupQuickActions() {
        const approveAllBtn = document.getElementById('approveAll');
        const exportDataBtn = document.getElementById('exportData');
        const sendRemindersBtn = document.getElementById('sendReminders');
        const viewHistoryBtn = document.getElementById('viewHistory');
        
        if (approveAllBtn) {
            approveAllBtn.addEventListener('click', () => this.approveAll());
        }
        
        if (exportDataBtn) {
            exportDataBtn.addEventListener('click', () => this.exportData());
        }
        
        if (sendRemindersBtn) {
            sendRemindersBtn.addEventListener('click', () => this.sendReminders());
        }
        
        if (viewHistoryBtn) {
            viewHistoryBtn.addEventListener('click', () => this.viewHistory());
        }
    }

    approveAll() {
        const rows = document.querySelectorAll('#empTable tbody tr.employer-row');
        if (rows.length === 0) {
            this.showToast('No employers to approve', 'info');
            return;
        }
        
        if (confirm(`Are you sure you want to approve ALL ${rows.length} pending employers?`)) {
            this.showLoading();
            
            // In a real application, make an AJAX call here
            // fetch('/admin/approveAllEmployers', { method: 'POST' })
            
            setTimeout(() => {
                this.hideLoading();
                
                // Show success animation for each row
                rows.forEach((row, index) => {
                    setTimeout(() => {
                        row.classList.add('success-animation');
                        setTimeout(() => {
                            row.remove();
                        }, 500);
                    }, index * 100);
                });
                
                this.showToast(`All ${rows.length} employers approved successfully`, 'success');
                
                // Update UI
                setTimeout(() => {
                    this.updateVisibleCount();
                    this.updatePagination();
                    this.updateChartData();
                }, rows.length * 100 + 500);
            }, 2000);
        }
    }

    sendReminders() {
        const rows = document.querySelectorAll('#empTable tbody tr.employer-row');
        if (rows.length === 0) {
            this.showToast('No employers to send reminders to', 'info');
            return;
        }
        
        this.showLoading();
        
        // Simulate sending reminders
        setTimeout(() => {
            this.hideLoading();
            
            // Add notification animation to each row
            rows.forEach((row, index) => {
                setTimeout(() => {
                    const badge = row.querySelector('.status-badge');
                    if (badge) {
                        const originalHTML = badge.innerHTML;
                        badge.innerHTML = '<i class="fas fa-bell"></i> Reminder Sent';
                        badge.classList.add('reminder-sent');
                        
                        setTimeout(() => {
                            badge.innerHTML = originalHTML;
                            badge.classList.remove('reminder-sent');
                        }, 2000);
                    }
                }, index * 200);
            });
            
            this.showToast(`Reminders sent to ${rows.length} employers`, 'success');
        }, 1500);
    }

    viewHistory() {
        this.showLoading();
        setTimeout(() => {
            this.hideLoading();
            this.showToast('Opening approval history...', 'info');
            // In a real application, redirect to history page
            // window.location.href = '/admin/approvalHistory';
        }, 1000);
    }

    setupAnimations() {
        // Add hover animations to cards
        const cards = document.querySelectorAll('.stat-card, .stats-card, .quick-actions-card, .page-title-section');
        cards.forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'translateY(-5px)';
                card.style.boxShadow = '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)';
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0)';
                card.style.boxShadow = 'var(--shadow-lg)';
            });
        });
        
        // Add hover animations to action buttons
        const actionButtons = document.querySelectorAll('.action-btn, .quick-action-btn, .btn');
        actionButtons.forEach(btn => {
            btn.addEventListener('mouseenter', () => {
                btn.style.transform = 'translateY(-2px)';
            });
            
            btn.addEventListener('mouseleave', () => {
                btn.style.transform = 'translateY(0)';
            });
        });
        
        // Add fade-in animation to new rows
        const rows = document.querySelectorAll('#empTable tbody tr.employer-row');
        rows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
            row.classList.add('fade-in');
        });
        
        // Add floating animation to icons
        const icons = document.querySelectorAll('.title-icon, .stat-icon');
        icons.forEach(icon => {
            icon.style.animation = 'float 6s infinite ease-in-out';
        });
    }

    setupLoading() {
        // Create loading overlay if not exists
        let overlay = document.getElementById('loadingOverlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.id = 'loadingOverlay';
            overlay.className = 'loading-overlay';
            overlay.innerHTML = `
                <div class="loading-spinner">
                    <i class="fas fa-spinner fa-spin"></i>
                    <p>Loading...</p>
                </div>
            `;
            document.body.appendChild(overlay);
        }
        
        this.showLoading = () => {
            overlay.style.display = 'flex';
        };
        
        this.hideLoading = () => {
            overlay.style.display = 'none';
        };
    }

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

    showToast(message, type = 'info') {
        const container = document.getElementById('toastContainer');
        if (!container) return;
        
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        
        // Set icon based on type
        let icon = 'info-circle';
        if (type === 'success') icon = 'check-circle';
        if (type === 'error') icon = 'exclamation-circle';
        if (type === 'warning') icon = 'exclamation-triangle';
        
        toast.innerHTML = `
            <i class="fas fa-${icon}"></i>
            <span>${message}</span>
            <button class="toast-close"><i class="fas fa-times"></i></button>
        `;
        
        // Set background color based on type
        let bgColor;
        switch(type) {
            case 'success': bgColor = 'var(--success)'; break;
            case 'error': bgColor = 'var(--danger)'; break;
            case 'warning': bgColor = 'var(--warning)'; break;
            default: bgColor = 'var(--info)';
        }
        
        toast.style.background = bgColor;
        
        // Add animation
        toast.style.animation = 'slideIn 0.3s ease';
        
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

    updateVisibleCount() {
        const visibleRows = document.querySelectorAll('#empTable tbody tr.employer-row[style*="display: """]');
        const visibleCountElement = document.getElementById('visibleCount');
        if (visibleCountElement) {
            visibleCountElement.textContent = visibleRows.length;
        }
    }

    updateNoDataMessage(visibleCount) {
        const noDataRow = document.querySelector('.no-data-row');
        if (noDataRow) {
            noDataRow.style.display = visibleCount === 0 ? '' : 'none';
        }
    }

    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    // Add custom animations CSS
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
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
        
        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(37, 99, 235, 0.4);
            }
            50% {
                box-shadow: 0 0 0 10px rgba(37, 99, 235, 0);
            }
        }
        
        @keyframes float {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }
        
        .fade-in {
            animation: slideIn 0.5s ease forwards;
            opacity: 0;
        }
        
        .pulse {
            animation: pulse 1s ease;
        }
        
        .success-animation {
            animation: slideOut 0.5s ease forwards;
        }
        
        .reminder-sent {
            background: rgba(59, 130, 246, 0.2) !important;
            border-color: var(--info) !important;
            color: var(--info) !important;
        }
        
        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        
        ::-webkit-scrollbar-track {
            background: var(--bg-secondary);
            border-radius: var(--radius-full);
        }
        
        ::-webkit-scrollbar-thumb {
            background: var(--border-medium);
            border-radius: var(--radius-full);
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: var(--primary-light);
        }
        
        /* Selection color */
        ::selection {
            background-color: rgba(37, 99, 235, 0.3);
            color: var(--text-primary);
        }
    `;
    document.head.appendChild(style);
    
    // Initialize the application
    window.pendingEmployersApp = new PendingEmployers();
});

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { PendingEmployers };
}