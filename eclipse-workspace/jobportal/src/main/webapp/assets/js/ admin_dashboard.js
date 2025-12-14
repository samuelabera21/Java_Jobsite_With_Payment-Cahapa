// JobPortal Admin Dashboard - Enhanced with Professional Animations
class AdminDashboard {
    constructor() {
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
        // Setup all functionality
        this.setupTheme();
        this.setupDateTime();
        this.setupAnimations();
        this.setupStatsCards();
        this.setupNotifications();
        this.setupQuickActions();
        this.setupHoverEffects();
        this.setupCardEffects();
    }

	setupTheme() {
	    // Check for saved theme preference
	    const savedTheme = localStorage.getItem('adminTheme');
	    
	    // Apply saved theme or default to light
	    if (savedTheme === 'dark') {
	        document.body.classList.add('dark');
	        this.updateThemeIcon('sun');
	    } else {
	        // Explicitly remove dark class and set light theme
	        document.body.classList.remove('dark');
	        this.updateThemeIcon('moon');
	        
	        // If no preference saved, save light as default
	        if (!savedTheme) {
	            localStorage.setItem('adminTheme', 'light');
	        }
	    }

	    // Theme toggle functionality
	    const themeToggle = document.getElementById('themeToggle');
	    if (themeToggle) {
	        themeToggle.addEventListener('click', () => {
	            const isDarkMode = document.body.classList.toggle('dark');
	            const theme = isDarkMode ? 'dark' : 'light';
	            localStorage.setItem('adminTheme', theme);
	            
	            // Update icon
	            this.updateThemeIcon(isDarkMode ? 'sun' : 'moon');
	            
	            // Show theme change toast
	            this.showToast(`Switched to ${theme} mode`, 'info');
	        });
	    }
	}

    updateThemeIcon(icon) {
        const themeToggle = document.getElementById('themeToggle');
        if (themeToggle) {
            themeToggle.innerHTML = `<i class="fas fa-${icon}"></i>`;
        }
    }

    setupDateTime() {
        // Update current date and time
        const updateDateTime = () => {
            const now = new Date();
            
            // Format date
            const dateOptions = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            };
            const dateString = now.toLocaleDateString('en-US', dateOptions);
            
            // Format time
            const timeOptions = { 
                hour: '2-digit', 
                minute: '2-digit',
                second: '2-digit'
            };
            const timeString = now.toLocaleTimeString('en-US', timeOptions);
            
            const dateTimeElement = document.getElementById('currentDateTime');
            if (dateTimeElement) {
                dateTimeElement.textContent = `${dateString} at ${timeString}`;
            }
            
            // Update last updated time
            const lastUpdatedElement = document.getElementById('lastUpdatedTime');
            if (lastUpdatedElement) {
                const updatedTimeString = now.toLocaleTimeString('en-US', { 
                    hour: '2-digit', 
                    minute: '2-digit' 
                });
                lastUpdatedElement.textContent = `${dateString.split(',')[0]} at ${updatedTimeString}`;
            }
        };

        // Update immediately and then every second
        updateDateTime();
        setInterval(updateDateTime, 1000);
    }

    setupAnimations() {
        // Fade-in animation for cards
        const fadeElements = document.querySelectorAll('.fade-in');
        fadeElements.forEach((el, index) => {
            setTimeout(() => {
                el.style.opacity = '1';
                el.style.transform = 'translateY(0)';
            }, index * 200);
        });

        // Animate stats counters
        this.animateStatsCounters();
    }

    animateStatsCounters() {
        const statValues = document.querySelectorAll('.stat-value');
        
        statValues.forEach(element => {
            const value = parseInt(element.textContent);
            if (!isNaN(value) && value > 0) {
                this.animateCounter(element, value);
            }
        });
    }

    animateCounter(element, target) {
        let count = 0;
        const increment = target / 20; // Faster animation
        const duration = 1000;
        const step = duration / (target / increment);

        const updateCount = () => {
            if (count < target) {
                count += increment;
                element.textContent = Math.floor(count);
                setTimeout(updateCount, step);
            } else {
                element.textContent = target;
            }
        };

        // Start animation after a short delay
        setTimeout(updateCount, 300);
    }

    setupStatsCards() {
        const statCards = document.querySelectorAll('.stat-card');
        
        statCards.forEach(card => {
            // Add click effect
            card.addEventListener('click', () => {
                this.createRippleEffect(card);
            });

            // Add hover effect
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'translateY(-8px) scale(1.02)';
            });

            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0) scale(1)';
            });
        });
    }

    setupNotifications() {
        const notificationBtn = document.getElementById('notificationBtn');
        if (notificationBtn) {
            notificationBtn.addEventListener('click', () => {
                this.showNotificationPanel();
            });
        }
    }

    setupQuickActions() {
        const quickStatsBtn = document.getElementById('quickStatsBtn');
        if (quickStatsBtn) {
            quickStatsBtn.addEventListener('click', (e) => {
                e.preventDefault();
                this.showQuickStats();
            });
        }

        // Add click effects to all action cards
        const actionCards = document.querySelectorAll('.action-card');
        actionCards.forEach(card => {
            card.addEventListener('click', (e) => {
                if (!e.target.closest('a')) {
                    this.createRippleEffect(card);
                }
            });
        });
    }

    setupHoverEffects() {
        // Add shine effect to cards on mouse move
        const cards = document.querySelectorAll('.stat-card, .action-card, .menu-card');
        
        cards.forEach(card => {
            card.addEventListener('mousemove', (e) => {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                card.style.setProperty('--mouse-x', `${x}px`);
                card.style.setProperty('--mouse-y', `${y}px`);
            });
        });
    }

    setupCardEffects() {
        // Add ripple effect to all interactive elements
        const interactiveElements = document.querySelectorAll('.btn, .theme-btn, .notification-btn, .logout-btn');
        
        interactiveElements.forEach(element => {
            element.addEventListener('click', (e) => {
                this.createRippleEffect(element, e);
            });
        });
    }

    // Utility Methods
    showNotificationPanel() {
        this.showToast('Notification panel would open here', 'info');
        
        // Create notification panel
        const panel = document.createElement('div');
        panel.className = 'notification-panel';
        panel.innerHTML = `
            <div class="notification-header">
                <h3><i class="fas fa-bell"></i> Notifications</h3>
                <button class="close-panel"><i class="fas fa-times"></i></button>
            </div>
            <div class="notification-list">
                <div class="notification-item">
                    <div class="notification-icon success">
                        <i class="fas fa-user-check"></i>
                    </div>
                    <div class="notification-content">
                        <h4>New Employers Approved</h4>
                        <p>2 employers have been approved</p>
                        <span class="notification-time">Just now</span>
                    </div>
                </div>
                <div class="notification-item">
                    <div class="notification-icon warning">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="notification-content">
                        <h4>System Update Available</h4>
                        <p>Update to v2.1 is ready</p>
                        <span class="notification-time">1 hour ago</span>
                    </div>
                </div>
                <div class="notification-item">
                    <div class="notification-icon info">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div class="notification-content">
                        <h4>New Users Registered</h4>
                        <p>5 new users joined today</p>
                        <span class="notification-time">2 hours ago</span>
                    </div>
                </div>
            </div>
            <div class="notification-footer">
                <a href="#" class="btn btn-outline">Mark All as Read</a>
                <a href="#" class="btn btn-primary">View All</a>
            </div>
        `;

        // Add styles
        panel.style.cssText = `
            position: fixed;
            top: 80px;
            right: 20px;
            width: 400px;
            max-width: 90vw;
            background: var(--bg-primary);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow-2xl);
            border: 1px solid var(--border-light);
            z-index: 1000;
            animation: slideDown 0.3s ease;
            overflow: hidden;
        `;

        document.body.appendChild(panel);

        // Close panel on click outside or close button
        const closePanel = () => {
            panel.style.animation = 'slideUp 0.3s ease forwards';
            setTimeout(() => panel.remove(), 300);
        };

        panel.querySelector('.close-panel').addEventListener('click', closePanel);
        
        // Close when clicking outside
        setTimeout(() => {
            document.addEventListener('click', (e) => {
                if (!panel.contains(e.target) && e.target !== document.getElementById('notificationBtn')) {
                    closePanel();
                }
            });
        }, 100);
    }

    showQuickStats() {
        this.showToast('Loading detailed analytics...', 'info');
        
        // Simulate loading
        setTimeout(() => {
            this.showToast('Analytics dashboard opened', 'success');
        }, 1000);
    }

    createRippleEffect(element, event) {
        const ripple = document.createElement('span');
        const rect = element.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);
        const x = (event ? event.clientX : rect.width / 2) - rect.left - size / 2;
        const y = (event ? event.clientY : rect.height / 2) - rect.top - size / 2;
        
        ripple.style.width = ripple.style.height = size + 'px';
        ripple.style.left = x + 'px';
        ripple.style.top = y + 'px';
        ripple.classList.add('ripple');
        
        const existingRipple = element.querySelector('.ripple');
        if (existingRipple) {
            existingRipple.remove();
        }
        
        element.appendChild(ripple);
        
        setTimeout(() => {
            ripple.remove();
        }, 600);
    }

    showToast(message, type = 'info') {
        // Create toast container if it doesn't exist
        let container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container';
            container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 10000;
                display: flex;
                flex-direction: column;
                gap: 10px;
            `;
            document.body.appendChild(container);
        }
        
        // Create toast
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
            <span>${message}</span>
            <button class="toast-close"><i class="fas fa-times"></i></button>
        `;
        
        // Toast styles
        toast.style.cssText = `
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 20px;
            background: ${type === 'success' ? 'var(--success)' : type === 'error' ? 'var(--danger)' : 'var(--primary)'};
            color: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-xl);
            animation: slideIn 0.3s ease;
            min-width: 300px;
        `;
        
        // Close button functionality
        const closeBtn = toast.querySelector('.toast-close');
        closeBtn.addEventListener('click', () => {
            toast.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => toast.remove(), 300);
        });
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (toast.parentNode) {
                toast.style.animation = 'slideOut 0.3s ease forwards';
                setTimeout(() => toast.remove(), 300);
            }
        }, 5000);
        
        container.appendChild(toast);
    }
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    @keyframes slideDown {
        from {
            transform: translateY(-20px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }
    
    @keyframes slideUp {
        from {
            transform: translateY(0);
            opacity: 1;
        }
        to {
            transform: translateY(-20px);
            opacity: 0;
        }
    }
    
    .ripple {
        position: absolute;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.3);
        transform: scale(0);
        animation: ripple 0.6s linear;
        pointer-events: none;
    }
    
    @keyframes ripple {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
    
    .toast-close {
        background: none;
        border: none;
        color: white;
        cursor: pointer;
        margin-left: auto;
        opacity: 0.7;
        transition: opacity 0.3s;
    }
    
    .toast-close:hover {
        opacity: 1;
    }
`;

document.head.appendChild(style);

// Initialize admin dashboard
document.addEventListener('DOMContentLoaded', () => {
    new AdminDashboard();
    
    // Add welcome message
    setTimeout(() => {
        const admin = new AdminDashboard();
        admin.showToast('Admin Dashboard loaded successfully!', 'success');
    }, 1000);
});

document.addEventListener('DOMContentLoaded', function() {
  const toggleBtn = document.getElementById('theme-toggle'); // Use your button's ID
  if (toggleBtn) {
    toggleBtn.addEventListener('click', function() {
      document.body.classList.toggle('dark-mode');
      // Optional: Save preference to localStorage
      if (document.body.classList.contains('dark-mode')) {
        localStorage.setItem('theme', 'dark');
      } else {
        localStorage.setItem('theme', 'light');
      }
    });
  }
});