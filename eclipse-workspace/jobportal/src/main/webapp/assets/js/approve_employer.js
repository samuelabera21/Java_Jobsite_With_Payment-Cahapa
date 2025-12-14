// ===== DOM Elements =====
const themeToggleBtn = document.getElementById('themeToggle');
const body = document.body;

// ===== Theme Management =====
function initTheme() {
    // Check localStorage for saved theme
    const savedTheme = localStorage.getItem('adminTheme');
    const isDark = savedTheme === 'dark' || 
                  (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches);
    
    if (isDark) {
        enableDarkMode();
    } else {
        enableLightMode();
    }
}

function enableDarkMode() {
    body.classList.add('dark');
    localStorage.setItem('adminTheme', 'dark');
    if (themeToggleBtn) {
        themeToggleBtn.innerHTML = '<i class="fas fa-sun"></i><span>Light Mode</span>';
    }
}

function enableLightMode() {
    body.classList.remove('dark');
    localStorage.setItem('adminTheme', 'light');
    if (themeToggleBtn) {
        themeToggleBtn.innerHTML = '<i class="fas fa-moon"></i><span>Dark Mode</span>';
    }
}

function toggleTheme() {
    if (body.classList.contains('dark')) {
        enableLightMode();
    } else {
        enableDarkMode();
    }
}

// ===== Animation Effects =====
function addButtonEffects() {
    const buttons = document.querySelectorAll('.btn');
    
    buttons.forEach(btn => {
        // Add click animation
        btn.addEventListener('click', function(e) {
            // For cancel button, add confirmation
            if (this.classList.contains('btn-cancel')) {
                if (!confirm('Are you sure you want to cancel? Any changes will be lost.')) {
                    e.preventDefault();
                    return;
                }
            }
            
            // For approve button, show loading state
            if (this.classList.contains('btn-approve')) {
                const originalHTML = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                this.style.pointerEvents = 'none';
                
                // Reset after 2 seconds (simulating processing)
                setTimeout(() => {
                    this.innerHTML = originalHTML;
                    this.style.pointerEvents = 'auto';
                }, 2000);
            }
        });
        
        // Add hover effects
        btn.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
        });
        
        btn.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
}

// ===== Modal Effects =====
function addModalEffects() {
    const modal = document.querySelector('.modal');
    
    // Click outside to close (if needed)
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('overlay')) {
            // Optional: Add confirmation before closing
            if (confirm('Close without approving?')) {
                window.location.href = '<%= request.getContextPath() %>/admin/manageUsers';
            }
        }
    });
    
    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Escape key to cancel
        if (e.key === 'Escape') {
            if (confirm('Cancel approval?')) {
                window.location.href = '<%= request.getContextPath() %>/admin/manageUsers';
            }
        }
        
        // Enter key to approve
        if (e.key === 'Enter' && !e.target.matches('button, a, input, textarea')) {
            document.querySelector('.btn-approve').click();
        }
    });
}

// ===== Initialize Everything =====
document.addEventListener('DOMContentLoaded', function() {
    // Initialize theme
    initTheme();
    
    // Add theme toggle functionality
    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', toggleTheme);
    }
    
    // Add button effects
    addButtonEffects();
    
    // Add modal effects
    addModalEffects();
    
    // Auto-focus on approve button for accessibility
    setTimeout(() => {
        const approveBtn = document.querySelector('.btn-approve');
        if (approveBtn) {
            approveBtn.focus();
        }
    }, 100);
});

// ===== Optional: Add to admin theme sync =====
// If you want this page to sync with main admin dashboard theme
window.addEventListener('storage', function(e) {
    if (e.key === 'adminTheme') {
        if (e.newValue === 'dark') {
            enableDarkMode();
        } else {
            enableLightMode();
        }
    }
});