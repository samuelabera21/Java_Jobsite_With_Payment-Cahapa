/**
 * CV Templates Management
 * Enhanced with modern features and animations
 * @class CVTemplates
 * @version 1.0.0
 */

/* global document, window, localStorage, console */

/**
 * Main CVTemplates class
 */
class CVTemplates {
    
    /**
     * Creates a new CVTemplates instance
     * @constructor
     */
    constructor() {
        /** @type {string} Current theme */
        this.currentTheme = localStorage.getItem('adminTheme') || 'light';
        
        /** @type {string|null} Delete confirmation href */
        this.confirmHref = null;
        
        /** @type {number} Download count */
        this.downloadCount = 0;
        
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
        this.setupConfirmations();
        this.setupTableInteractions();
        this.setupAnimations();
        this.setupLoading();
        this.setupNotifications();
        this.setupStats();
        this.setupDownloadTracking();
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
     * Set up confirmation dialogs for delete actions
     * @method setupConfirmations
     * @returns {void}
     */
    setupConfirmations() {
        // Handle delete buttons with confirmation
        document.addEventListener('click', (e) => {
            const deleteBtn = e.target.closest('[data-confirm="delete"]');
            if (deleteBtn) {
                e.preventDefault();
                this.showDeleteConfirmation(deleteBtn);
            }
        });
        
        // Setup confirmation modal buttons
        const cancelBtn = document.getElementById('confirmCancel');
        const deleteBtn = document.getElementById('confirmDelete');
        const modal = document.getElementById('confirmationModal');
        
        if (cancelBtn) {
            cancelBtn.addEventListener('click', () => {
                if (modal) {
                    modal.classList.remove('active');
                }
            });
        }
        
        if (deleteBtn) {
            deleteBtn.addEventListener('click', () => {
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
     * Show delete confirmation dialog
     * @method showDeleteConfirmation
     * @param {HTMLElement} button - Button element that triggered confirmation
     * @returns {void}
     */
    showDeleteConfirmation(button) {
        const href = button.getAttribute('href');
        const modal = document.getElementById('confirmationModal');
        
        if (!modal || !href) {
            return;
        }
        
        this.confirmHref = href;
        modal.classList.add('active');
    }
    
    /**
     * Set up table interactions
     * @method setupTableInteractions
     * @returns {void}
     */
    setupTableInteractions() {
        // Add row hover effects
        const rows = document.querySelectorAll('.template-row');
        rows.forEach((row) => {
            row.addEventListener('mouseenter', () => {
                row.style.backgroundColor = 'rgba(37, 99, 235, 0.05)';
            });
            
            row.addEventListener('mouseleave', () => {
                if (!row.classList.contains('selected')) {
                    row.style.backgroundColor = '';
                }
            });
            
            // Add click effect for selection
            row.addEventListener('click', (e) => {
                if (!e.target.closest('.btn-action')) {
                    rows.forEach((r) => {
                        r.classList.remove('selected');
                        r.style.backgroundColor = '';
                    });
                    row.classList.add('selected');
                    row.style.backgroundColor = 'rgba(37, 99, 235, 0.1)';
                }
            });
        });
        
        // Add file type colors
        this.colorizeFileTypes();
    }
    
    /**
     * Add color coding for different file types
     * @method colorizeFileTypes
     * @returns {void}
     */
    colorizeFileTypes() {
        const fileIcons = document.querySelectorAll('.file-info i');
        fileIcons.forEach((icon) => {
            const parent = icon.closest('.file-info');
            if (parent.textContent.includes('PDF')) {
                icon.style.color = 'var(--danger)';
            } else if (parent.textContent.includes('DOCX') || parent.textContent.includes('DOC')) {
                icon.style.color = 'var(--info)';
            } else {
                icon.style.color = 'var(--text-muted)';
            }
        });
    }
    
    /**
     * Set up download tracking
     * @method setupDownloadTracking
     * @returns {void}
     */
    setupDownloadTracking() {
        const downloadLinks = document.querySelectorAll('.btn-download');
        downloadLinks.forEach((link) => {
            link.addEventListener('click', () => {
                this.trackDownload();
            });
        });
    }
    
    /**
     * Track download and update stats
     * @method trackDownload
     * @returns {void}
     */
    trackDownload() {
        this.downloadCount++;
        const downloadCountEl = document.getElementById('downloadCount');
        if (downloadCountEl) {
            downloadCountEl.textContent = this.downloadCount.toString();
            downloadCountEl.style.animation = 'pulse 0.5s ease';
            setTimeout(() => {
                downloadCountEl.style.animation = '';
            }, 500);
        }
        
        // Save to localStorage
        localStorage.setItem('cvTemplateDownloads', this.downloadCount.toString());
    }
    
    /**
     * Set up statistics
     * @method setupStats
     * @returns {void}
     */
    setupStats() {
        // Load download count from localStorage
        const savedCount = localStorage.getItem('cvTemplateDownloads');
        if (savedCount) {
            this.downloadCount = parseInt(savedCount, 10);
            const downloadCountEl = document.getElementById('downloadCount');
            if (downloadCountEl) {
                downloadCountEl.textContent = this.downloadCount.toString();
            }
        }
        
        // Add animation to stats cards
        const statsCards = document.querySelectorAll('.stats-card');
        statsCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.2}s`;
            card.classList.add('fade-in');
            
            // Add hover animation
            card.addEventListener('mouseenter', () => {
                const icon = card.querySelector('.stats-icon');
                if (icon) {
                    icon.style.transform = 'scale(1.1) rotate(5deg)';
                }
            });
            
            card.addEventListener('mouseleave', () => {
                const icon = card.querySelector('.stats-icon');
                if (icon) {
                    icon.style.transform = 'scale(1) rotate(0deg)';
                }
            });
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
        
        // Add ripple to all action buttons
        const actionButtons = document.querySelectorAll('.btn-action');
        actionButtons.forEach(addRipple);
        
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
            
            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.1); }
            }
            
            .fade-in {
                animation: slideIn 0.3s ease forwards;
                opacity: 0;
            }
            
            .stats-icon {
                transition: all var(--transition-base);
            }
            
            .btn-download {
                transition: all var(--transition-base);
            }
            
            .btn-download:hover i {
                animation: bounce 0.5s ease;
            }
            
            @keyframes bounce {
                0%, 100% { transform: translateY(0); }
                50% { transform: translateY(-5px); }
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
        
        // Show loading on navigation
        const navLinks = document.querySelectorAll('a[href*="admin/"]:not(.btn-action)');
        navLinks.forEach((link) => {
            link.addEventListener('click', (e) => {
                if (link.getAttribute('href').includes('deleteCVTemplate')) {
                    return; // Don't show loading for delete (handled by confirmation)
                }
                this.showLoading();
            });
        });
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
    
    /**
     * Export templates data (for future use)
     * @method exportTemplates
     * @returns {void}
     */
    exportTemplates() {
        this.showLoading();
        
        setTimeout(() => {
            this.hideLoading();
            
            // Get template data
            const templates = [];
            const rows = document.querySelectorAll('.template-row');
            rows.forEach((row) => {
                const id = row.querySelector('.template-id').textContent;
                const name = row.querySelector('.template-name strong').textContent;
                const description = row.querySelector('.template-description').textContent;
                const fileType = row.querySelector('.file-info').textContent.trim();
                
                templates.push({
                    id: parseInt(id, 10),
                    name: name,
                    description: description,
                    fileType: fileType,
                    exportDate: new Date().toISOString()
                });
            });
            
            // Create and download JSON file
            const json = JSON.stringify(templates, null, 2);
            const blob = new Blob([json], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `cv_templates_export_${new Date().toISOString().split('T')[0]}.json`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
            
            this.showToast('Templates exported successfully', 'success');
        }, 1000);
    }
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.cvTemplatesApp = new CVTemplates();
});

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { CVTemplates };
}