/**
 * Seeker Dashboard Management
 * Enhanced with client-side animations and interactions
 * @class SeekerDashboard
 * @version 1.0.0
 */

/* global document, window, localStorage, console */

/**
 * @typedef {Object} DashboardStats
 * @property {number} applications - Number of applications
 * @property {number} interviews - Number of interviews
 * @property {number} savedJobs - Number of saved jobs
 * @property {number} profileViews - Number of profile views
 */

/**
 * Main SeekerDashboard class
 */
class SeekerDashboard {
    
    /**
     * Creates a new SeekerDashboard instance
     * @constructor
     */
    constructor() {
        /** @type {string} Current theme */
        this.currentTheme = localStorage.getItem('seekerTheme') || 'light';
        
        /** @type {DashboardStats} Dashboard statistics */
        this.stats = {
            applications: 0,
            interviews: 0,
            savedJobs: 0,
            profileViews: 0
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
        this.loadStatsData();
        this.setupTheme();
        this.setupStatsAnimation();
        this.setupConfirmationModal();
        this.setupLoading();
        this.setupToast();
        this.setupAnimations();
        this.setupEventListeners();
        this.setupHoverEffects();
    }
    
    /**
     * Load stats data from hidden JSON element
     * @method loadStatsData
     * @returns {void}
     */
    loadStatsData() {
        try {
            const statsData = document.getElementById('dashboardStats');
            if (statsData) {
                this.stats = JSON.parse(statsData.textContent);
            }
        } catch (error) {
            console.error('Error loading dashboard stats:', error);
            this.showToast('Error loading dashboard data', 'error');
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
            localStorage.setItem('seekerTheme', 'light');
            this.currentTheme = 'light';
            this.updateThemeButton('dark');
            this.showToast('Light mode enabled', 'info');
        } else {
            body.classList.add('dark');
            localStorage.setItem('seekerTheme', 'dark');
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
     * Set up stats number animation
     * @method setupStatsAnimation
     * @returns {void}
     */
    setupStatsAnimation() {
        // Intersection Observer for stats animation
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    this.animateStats();
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.5 });
        
        const statsContainer = document.querySelector('.stats-container');
        if (statsContainer) {
            observer.observe(statsContainer);
        }
    }
    
    /**
     * Animate statistics numbers
     * @method animateStats
     * @returns {void}
     */
    animateStats() {
        Object.keys(this.stats).forEach(stat => {
            const element = document.getElementById(`stat${this.capitalizeFirst(stat)}`);
            if (element) {
                this.animateCount(element, this.stats[stat]);
            }
        });
    }
    
    /**
     * Animate counting up to target number
     * @method animateCount
     * @param {HTMLElement} element - Element to animate
     * @param {number} target - Target number
     * @returns {void}
     */
    animateCount(element, target) {
        let current = 0;
        const increment = target / 100;
        const duration = 2000;
        const interval = duration / 100;
        
        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                element.textContent = target;
                clearInterval(timer);
            } else {
                element.textContent = Math.floor(current);
            }
        }, interval);
    }
    
    /**
     * Set up confirmation modal
     * @method setupConfirmationModal
     * @returns {void}
     */
    setupConfirmationModal() {
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
                if (modal) {
                    modal.classList.remove('active');
                    this.showToast('Action completed successfully', 'success');
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
     * Set up toast notifications
     * @method setupToast
     * @returns {void}
     */
    setupToast() {
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
     * Set up animations
     * @method setupAnimations
     * @returns {void}
     */
    setupAnimations() {
        // Add custom animations CSS
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideOut {
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }
            
            .action-card {
                position: relative;
                overflow: hidden;
            }
            
            .action-card::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: linear-gradient(
                    45deg,
                    transparent 30%,
                    rgba(255, 255, 255, 0.1) 50%,
                    transparent 70%
                );
                transform: rotate(45deg);
                transition: transform 0.6s;
            }
            
            .action-card:hover::before {
                transform: rotate(45deg) translate(20%, 20%);
            }
            
            .quick-link {
                position: relative;
                overflow: hidden;
            }
            
            .quick-link::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.2);
                transform: translate(-50%, -50%);
                transition: width 0.6s, height 0.6s;
            }
            
            .quick-link:hover::before {
                width: 300px;
                height: 300px;
            }
            
            .stat-card:hover .stat-icon {
                animation: pulse 1s infinite;
            }
            
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.1); }
                100% { transform: scale(1); }
            }
        `;
        document.head.appendChild(style);
    }
    
    /**
     * Set up hover effects
     * @method setupHoverEffects
     * @returns {void}
     */
    setupHoverEffects() {
        // Add tooltips to quick links
        const quickLinks = document.querySelectorAll('.quick-link');
        quickLinks.forEach(link => {
            link.addEventListener('mouseenter', () => {
                const title = link.querySelector('span').textContent;
                link.setAttribute('title', title);
            });
        });
    }
    
    /**
     * Set up event listeners
     * @method setupEventListeners
     * @returns {void}
     */
    setupEventListeners() {
        // Show loading on navigation
        document.addEventListener('click', (e) => {
            const link = e.target.closest('a');
            if (link && link.href && !link.href.includes('#')) {
                // Don't prevent default for regular navigation
                // Just show loading indicator
                this.showLoading();
                
                // Hide loading after navigation
                setTimeout(() => {
                    this.hideLoading();
                }, 1000);
            }
        });
        
        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            // Ctrl/Cmd + 1: View Jobs
            if ((e.ctrlKey || e.metaKey) && e.key === '1') {
                e.preventDefault();
                window.location.href = `${window.location.pathname.split('/dashboard')[0]}/seeker/viewJobs`;
            }
            
            // Ctrl/Cmd + 2: My Applications
            if ((e.ctrlKey || e.metaKey) && e.key === '2') {
                e.preventDefault();
                window.location.href = `${window.location.pathname.split('/dashboard')[0]}/seeker/applications`;
            }
            
            // Ctrl/Cmd + 3: Edit Profile
            if ((e.ctrlKey || e.metaKey) && e.key === '3') {
                e.preventDefault();
                window.location.href = `${window.location.pathname.split('/dashboard')[0]}/seeker/profile`;
            }
            
            // F5: Refresh dashboard
            if (e.key === 'F5') {
                e.preventDefault();
                this.refreshDashboard();
            }
        });
        
        // Show welcome toast on first visit
        if (!localStorage.getItem('seekerWelcomeShown')) {
            setTimeout(() => {
                this.showToast('Welcome to your Job Seeker Dashboard! Explore all features.', 'success');
                localStorage.setItem('seekerWelcomeShown', 'true');
            }, 1500);
        }
    }
    
    /**
     * Refresh dashboard
     * @method refreshDashboard
     * @returns {void}
     */
    refreshDashboard() {
        this.showLoading();
        
        // Simulate refresh
        setTimeout(() => {
            this.animateStats();
            this.showToast('Dashboard refreshed successfully', 'info');
            this.hideLoading();
        }, 1000);
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
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.seekerDashboard = new SeekerDashboard();
});

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { SeekerDashboard };
}