/**
 * Emergency Page Fixer
 * Load this AFTER all other JS files
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Page fixer running...');
    
    // Make sure all content is visible
    var mainContent = document.querySelector('.apply-container') || 
                     document.querySelector('.dashboard-container') ||
                     document.querySelector('.edit-profile-container') ||
                     document.querySelector('.profile-container');
    
    if (mainContent) {
        mainContent.style.display = 'block';
        mainContent.style.visibility = 'visible';
        mainContent.style.opacity = '1';
    }
    
    // Remove any hiding styles
    var allElements = document.querySelectorAll('*');
    allElements.forEach(function(el) {
        if (el.style.display === 'none') {
            el.style.display = '';
        }
        if (el.style.visibility === 'hidden') {
            el.style.visibility = 'visible';
        }
        if (el.style.opacity === '0') {
            el.style.opacity = '1';
        }
    });
    
    // Force show body
    document.body.style.display = 'block';
    document.body.style.visibility = 'visible';
    
    console.log('Page fixer completed');
});