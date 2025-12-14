/**
 * View Jobs Management - Seeker
 * Enhanced with toggle functionality and better filters
 * @class ViewJobs
 * @version 2.0.0
 */

/* global document, window, localStorage, console */

// ES5 Compatible Class Pattern
function ViewJobs() {
    this.savedJobs = JSON.parse(localStorage.getItem('savedJobs')) || [];
    this.currentView = 'table';
    this.currentSort = 'recent';
    this.filters = {
        location: '',
        category: '',
        type: [],
        minSalary: '',
        maxSalary: ''
    };
    this.currentPage = 1;
    this.jobsPerPage = 10;
    
    this.init();
}

ViewJobs.prototype.init = function() {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', this.setup.bind(this));
    } else {
        this.setup();
    }
};

ViewJobs.prototype.setup = function() {
    this.setupToggles();
    this.setupSaveButtons();
    this.setupSearch();
    this.setupFilters();
    this.setupSorting();
    this.setupViewSwitching();
    this.setupPagination();
    this.setupApplyButtons();
    this.setupTableInteractions();
    this.setupKeyboardNavigation();
    this.setupTooltips();
    this.updateSavedCount();
    this.applyClientSideFilters();
};

ViewJobs.prototype.setupToggles = function() {
    var self = this;
    
    // Toggle recommended section
    var toggleRecommended = document.getElementById('toggleRecommended');
    var recommendedContent = document.getElementById('recommendedContent');
    
    if (toggleRecommended && recommendedContent) {
        toggleRecommended.addEventListener('click', function() {
            var isVisible = recommendedContent.style.display !== 'none';
            recommendedContent.style.display = isVisible ? 'none' : 'block';
            toggleRecommended.innerHTML = isVisible ? 
                '<i class="fas fa-eye"></i><span>Show</span>' : 
                '<i class="fas fa-eye-slash"></i><span>Hide</span>';
            self.showToast(isVisible ? 'Recommended jobs hidden' : 'Recommended jobs shown', 'info');
        });
    }
    
    // Toggle advanced filters
    var toggleFilters = document.getElementById('toggleFilters');
    var advancedFilters = document.getElementById('advancedFilters');
    
    if (toggleFilters && advancedFilters) {
        toggleFilters.addEventListener('click', function() {
            var isVisible = advancedFilters.style.display !== 'none';
            advancedFilters.style.display = isVisible ? 'none' : 'block';
            toggleFilters.innerHTML = isVisible ? 
                '<i class="fas fa-sliders-h"></i><span>Show Filters</span>' : 
                '<i class="fas fa-times"></i><span>Hide Filters</span>';
            self.showToast(isVisible ? 'Filters hidden' : 'Filters shown', 'info');
        });
    }
};

ViewJobs.prototype.setupSaveButtons = function() {
    var self = this;
    
    document.addEventListener('click', function(e) {
        var saveBtn = e.target.closest('.btn-save, .btn-card-save');
        if (!saveBtn) return;
        
        e.preventDefault();
        var jobId = saveBtn.dataset.jobId;
        var jobTitle = self.getJobTitle(saveBtn);
        
        self.toggleSaveJob(jobId, jobTitle, saveBtn);
    });
};

ViewJobs.prototype.getJobTitle = function(element) {
    if (element.closest('.job-row, .recommended-job-row')) {
        return element.closest('tr').querySelector('strong').textContent;
    } else if (element.closest('.job-card')) {
        return element.closest('.job-card').querySelector('.job-card-title').textContent;
    }
    return 'Job';
};

ViewJobs.prototype.toggleSaveJob = function(jobId, jobTitle, button) {
    var icon = button.querySelector('i');
    var isSaved = this.savedJobs.indexOf(jobId) > -1;
    
    if (isSaved) {
        // Remove from saved
        var newSavedJobs = [];
        for (var i = 0; i < this.savedJobs.length; i++) {
            if (this.savedJobs[i] !== jobId) {
                newSavedJobs.push(this.savedJobs[i]);
            }
        }
        this.savedJobs = newSavedJobs;
        icon.className = 'far fa-bookmark';
        this.showToast('Removed "' + jobTitle + '" from saved jobs', 'info');
    } else {
        // Add to saved
        this.savedJobs.push(jobId);
        icon.className = 'fas fa-bookmark';
        button.classList.add('saved');
        this.showToast('Saved "' + jobTitle + '" to your list', 'success');
    }
    
    localStorage.setItem('savedJobs', JSON.stringify(this.savedJobs));
    this.updateSavedCount();
    
    // Update button state
    var self = this;
    setTimeout(function() {
        button.classList.toggle('saved', !isSaved);
    }, 300);
};

ViewJobs.prototype.updateSavedCount = function() {
    var savedCountEl = document.getElementById('savedCount');
    if (savedCountEl) {
        savedCountEl.textContent = this.savedJobs.length;
    }
};

ViewJobs.prototype.setupSearch = function() {
    var self = this;
    var searchForm = document.getElementById('searchForm');
    var searchInput = document.getElementById('searchInput');
    
    if (searchForm && searchInput) {
        // Add instant search feedback
        searchInput.addEventListener('input', function(e) {
            self.highlightSearchTerms(e.target.value);
        });
        
        // Add search suggestions
        searchInput.addEventListener('focus', function() {
            self.showSearchSuggestions();
        });
    }
};

ViewJobs.prototype.highlightSearchTerms = function(term) {
    if (!term.trim()) {
        var highlights = document.querySelectorAll('.search-highlight');
        for (var i = 0; i < highlights.length; i++) {
            highlights[i].classList.remove('search-highlight');
        }
        return;
    }
    
    var regex = new RegExp('(' + term + ')', 'gi');
    var jobTitles = document.querySelectorAll('.job-title-wrapper strong, .job-card-title');
    
    for (var i = 0; i < jobTitles.length; i++) {
        var title = jobTitles[i];
        var text = title.textContent;
        var highlighted = text.replace(regex, '<mark class="search-highlight">$1</mark>');
        title.innerHTML = highlighted;
    }
};

ViewJobs.prototype.showSearchSuggestions = function() {
    // This would normally fetch suggestions from an API
    console.log('Show search suggestions');
};

ViewJobs.prototype.setupFilters = function() {
    var self = this;
    
    // Location clear button
    var clearButtons = document.querySelectorAll('.btn-clear');
    for (var i = 0; i < clearButtons.length; i++) {
        clearButtons[i].addEventListener('click', function(e) {
            var targetId = e.target.closest('.btn-clear').dataset.target;
            var input = document.getElementById(targetId);
            if (input) {
                input.value = '';
                input.focus();
                self.showToast(targetId.replace('Input', '') + ' cleared', 'info');
            }
        });
    }
    
    // Checkbox filters
    var checkboxes = document.querySelectorAll('.filter-option input[type="checkbox"]');
    for (var i = 0; i < checkboxes.length; i++) {
        checkboxes[i].addEventListener('change', function() {
            self.updateTypeFilters();
            self.showToast('Filter updated', 'info');
        });
    }
    
    // Salary presets
    var presets = document.querySelectorAll('.btn-preset');
    for (var i = 0; i < presets.length; i++) {
        presets[i].addEventListener('click', function() {
            var minSalary = document.getElementById('minSalary');
            var maxSalary = document.getElementById('maxSalary');
            
            if (minSalary && maxSalary) {
                minSalary.value = this.dataset.min;
                maxSalary.value = this.dataset.max;
                self.showToast('Salary range set to ' + this.textContent, 'info');
            }
        });
    }
    
    // Clear all filters
    var clearFiltersBtn = document.getElementById('clearFilters');
    if (clearFiltersBtn) {
        clearFiltersBtn.addEventListener('click', function() {
            self.clearAllFilters();
            self.showToast('All filters cleared', 'info');
        });
    }
    
    // Filter form submission
    var filterForm = document.getElementById('filterForm');
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            self.applyFilters();
        });
    }
};

ViewJobs.prototype.updateTypeFilters = function() {
    var checkboxes = document.querySelectorAll('.filter-option input[type="checkbox"]:checked');
    this.filters.type = [];
    for (var i = 0; i < checkboxes.length; i++) {
        this.filters.type.push(checkboxes[i].value);
    }
    
    // Update UI to show filters are active
    var filtersApplied = document.getElementById('filtersApplied');
    if (filtersApplied) {
        filtersApplied.style.display = this.filters.type.length > 0 ? 'inline' : 'none';
    }
};

ViewJobs.prototype.clearAllFilters = function() {
    // Clear all filter inputs
    var filterInputs = document.querySelectorAll('.filter-input');
    for (var i = 0; i < filterInputs.length; i++) {
        filterInputs[i].value = '';
    }
    
    var filterSelects = document.querySelectorAll('.filter-select');
    for (var i = 0; i < filterSelects.length; i++) {
        filterSelects[i].selectedIndex = 0;
    }
    
    var checkboxes = document.querySelectorAll('.filter-option input[type="checkbox"]');
    for (var i = 0; i < checkboxes.length; i++) {
        checkboxes[i].checked = false;
    }
    
    // Reset filter state
    this.filters = {
        location: '',
        category: '',
        type: [],
        minSalary: '',
        maxSalary: ''
    };
    
    // Update UI
    var filtersApplied = document.getElementById('filtersApplied');
    if (filtersApplied) {
        filtersApplied.style.display = 'none';
    }
};

ViewJobs.prototype.applyFilters = function() {
    var self = this;
    
    // Collect filter values
    var locationInput = document.getElementById('locationInput');
    var categorySelect = document.getElementById('categorySelect');
    var minSalaryInput = document.getElementById('minSalary');
    var maxSalaryInput = document.getElementById('maxSalary');
    
    this.filters.location = locationInput ? locationInput.value : '';
    this.filters.category = categorySelect ? categorySelect.value : '';
    this.filters.minSalary = minSalaryInput ? minSalaryInput.value : '';
    this.filters.maxSalary = maxSalaryInput ? maxSalaryInput.value : '';
    
    // Show loading
    this.showLoading();
    
    // In a real app, this would submit the form
    // For now, simulate filtering
    setTimeout(function() {
        self.applyClientSideFilters();
        self.hideLoading();
        self.showToast('Filters applied successfully', 'success');
    }, 1000);
};

ViewJobs.prototype.applyClientSideFilters = function() {
    var jobRows = document.querySelectorAll('.job-row, .recommended-job-row');
    var jobCards = document.querySelectorAll('.job-card');
    
    var visibleCount = 0;
    
    // Filter table rows
    for (var i = 0; i < jobRows.length; i++) {
        var row = jobRows[i];
        var title = row.querySelector('strong').textContent.toLowerCase();
        var location = row.cells[1].textContent.toLowerCase();
        var category = row.cells[2].textContent.toLowerCase();
        var type = row.cells[3].textContent.toLowerCase();
        var salary = row.cells[4].textContent.toLowerCase();
        
        var matches = this.matchesFilters(title, location, category, type, salary);
        row.style.display = matches ? '' : 'none';
        if (matches) visibleCount++;
    }
    
    // Filter grid cards
    for (var i = 0; i < jobCards.length; i++) {
        var card = jobCards[i];
        var title = card.querySelector('.job-card-title').textContent.toLowerCase();
        var location = card.querySelector('.job-card-detail:nth-child(1) span').textContent.toLowerCase();
        var category = card.querySelector('.job-card-detail:nth-child(2) span').textContent.toLowerCase();
        var type = card.querySelector('.job-card-detail:nth-child(3) span').textContent.toLowerCase();
        var salaryEl = card.querySelector('.job-card-detail.salary span');
        var salary = salaryEl ? salaryEl.textContent.toLowerCase() : '';
        
        var matches = this.matchesFilters(title, location, category, type, salary);
        card.style.display = matches ? '' : 'none';
    }
    
    // Update count
    var jobCount = document.querySelector('.job-count');
    if (jobCount) {
        jobCount.textContent = visibleCount;
    }
};

ViewJobs.prototype.matchesFilters = function(title, location, category, type, salary) {
    // Location filter
    if (this.filters.location && location.indexOf(this.filters.location.toLowerCase()) === -1) {
        return false;
    }
    
    // Category filter
    if (this.filters.category && category !== this.filters.category.toLowerCase()) {
        return false;
    }
    
    // Type filter
    if (this.filters.type.length > 0) {
        var typeMatch = false;
        for (var i = 0; i < this.filters.type.length; i++) {
            if (type.indexOf(this.filters.type[i]) !== -1) {
                typeMatch = true;
                break;
            }
        }
        if (!typeMatch) return false;
    }
    
    // Salary filter
    if (this.filters.minSalary || this.filters.maxSalary) {
        var salaryNum = this.extractSalaryNumber(salary);
        if (salaryNum === null) return true; // If no salary specified, show it
        
        if (this.filters.minSalary && salaryNum < parseInt(this.filters.minSalary)) {
            return false;
        }
        
        if (this.filters.maxSalary && salaryNum > parseInt(this.filters.maxSalary)) {
            return false;
        }
    }
    
    return true;
};

ViewJobs.prototype.extractSalaryNumber = function(salaryText) {
    var match = salaryText.match(/\$?(\d+[.,]?\d*)/);
    return match ? parseFloat(match[1].replace(',', '')) : null;
};

ViewJobs.prototype.setupSorting = function() {
    var self = this;
    var sortSelect = document.getElementById('sortSelect');
    if (!sortSelect) return;
    
    sortSelect.value = this.currentSort;
    
    sortSelect.addEventListener('change', function(e) {
        self.currentSort = e.target.value;
        self.sortJobs();
        self.showToast('Sorted by: ' + self.getSortLabel(self.currentSort), 'info');
    });
};

ViewJobs.prototype.getSortLabel = function(sortValue) {
    var labels = {
        'recent': 'Most Recent',
        'title_asc': 'Title (A-Z)',
        'title_desc': 'Title (Z-A)',
        'salary_high': 'Salary (High to Low)',
        'salary_low': 'Salary (Low to High)'
    };
    return labels[sortValue] || 'Most Recent';
};

ViewJobs.prototype.sortJobs = function() {
    var jobRows = document.querySelectorAll('.job-row:not([style*="display: none"])');
    var tableBody = document.getElementById('jobsTableBody');
    
    if (!tableBody || jobRows.length === 0) return;
    
    // Convert NodeList to Array
    var rowsArray = [];
    for (var i = 0; i < jobRows.length; i++) {
        rowsArray.push(jobRows[i]);
    }
    
    rowsArray.sort(function(a, b) {
        var titleA = a.querySelector('strong').textContent.toLowerCase();
        var titleB = b.querySelector('strong').textContent.toLowerCase();
        var salaryA = this.extractSalaryNumber(a.cells[4].textContent);
        var salaryB = this.extractSalaryNumber(b.cells[4].textContent);
        
        switch (this.currentSort) {
            case 'title_asc':
                return titleA.localeCompare(titleB);
            case 'title_desc':
                return titleB.localeCompare(titleA);
            case 'salary_high':
                return (salaryB || 0) - (salaryA || 0);
            case 'salary_low':
                return (salaryA || 0) - (salaryB || 0);
            case 'recent':
            default:
                // Assuming newer jobs are at the top of the list
                return 0;
        }
    }.bind(this));
    
    // Reorder jobs in table
    for (var i = 0; i < rowsArray.length; i++) {
        tableBody.appendChild(rowsArray[i]);
    }
};

ViewJobs.prototype.setupViewSwitching = function() {
    var self = this;
    var viewButtons = document.querySelectorAll('.btn-display');
    var tableView = document.querySelector('.table-view');
    var gridView = document.querySelector('.grid-view');
    
    for (var i = 0; i < viewButtons.length; i++) {
        viewButtons[i].addEventListener('click', function() {
            var view = this.dataset.view;
            if (view === self.currentView) return;
            
            // Update active button
            for (var j = 0; j < viewButtons.length; j++) {
                viewButtons[j].classList.remove('active');
            }
            this.classList.add('active');
            self.currentView = view;
            
            // Switch views
            if (tableView && gridView) {
                tableView.classList.remove('active');
                gridView.classList.remove('active');
                
                if (view === 'table') {
                    tableView.classList.add('active');
                } else {
                    gridView.classList.add('active');
                }
            }
            
            self.showToast('Switched to ' + (view === 'table' ? 'Table' : 'Grid') + ' view', 'info');
        });
    }
};

ViewJobs.prototype.setupPagination = function() {
    var self = this;
    var prevBtn = document.querySelector('.page-btn.prev');
    var nextBtn = document.querySelector('.page-btn.next');
    var pageNumbers = document.querySelectorAll('.page-number:not(.active)');
    
    if (prevBtn) {
        prevBtn.addEventListener('click', function() {
            if (!prevBtn.disabled) {
                self.navigatePage(self.currentPage - 1);
            }
        });
    }
    
    if (nextBtn) {
        nextBtn.addEventListener('click', function() {
            if (!nextBtn.disabled) {
                self.navigatePage(self.currentPage + 1);
            }
        });
    }
    
    for (var i = 0; i < pageNumbers.length; i++) {
        pageNumbers[i].addEventListener('click', function() {
            var page = parseInt(this.textContent);
            self.navigatePage(page);
        });
    }
};

ViewJobs.prototype.navigatePage = function(page) {
    this.currentPage = page;
    this.updatePagination();
    this.showToast('Page ' + page, 'info');
    
    // Scroll to top of jobs section
    var jobsSection = document.querySelector('.all-jobs-section');
    if (jobsSection) {
        jobsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
};

ViewJobs.prototype.updatePagination = function() {
    var totalJobs = document.querySelectorAll('.job-row:not([style*="display: none"])').length;
    var totalPages = Math.ceil(totalJobs / this.jobsPerPage);
    
    // Update page numbers
    var pageNumbers = document.querySelectorAll('.page-number');
    for (var i = 0; i < pageNumbers.length; i++) {
        pageNumbers[i].classList.remove('active');
    }
    
    // Update active page
    var activePage = document.querySelector('.page-number:nth-child(' + this.currentPage + ')');
    if (activePage) {
        activePage.classList.add('active');
    }
    
    // Update button states
    var prevBtn = document.querySelector('.page-btn.prev');
    var nextBtn = document.querySelector('.page-btn.next');
    
    if (prevBtn) {
        prevBtn.disabled = this.currentPage === 1;
    }
    
    if (nextBtn) {
        nextBtn.disabled = this.currentPage === totalPages || totalPages <= 1;
    }
    
    // Update showing range
    var showingStart = ((this.currentPage - 1) * this.jobsPerPage) + 1;
    var showingEnd = Math.min(this.currentPage * this.jobsPerPage, totalJobs);
    
    var showingStartEl = document.getElementById('showingStart');
    var showingEndEl = document.getElementById('showingEnd');
    
    if (showingStartEl) showingStartEl.textContent = showingStart;
    if (showingEndEl) showingEndEl.textContent = showingEnd;
};

ViewJobs.prototype.setupApplyButtons = function() {
    var self = this;
    
    document.addEventListener('click', function(e) {
        var applyBtn = e.target.closest('.btn-apply');
        if (!applyBtn) return;
        
        // Add loading state
        var originalHTML = applyBtn.innerHTML;
        applyBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Applying...';
        applyBtn.classList.add('loading');
        
        // Reset after delay (in real app, this would be after form submission)
        setTimeout(function() {
            applyBtn.innerHTML = originalHTML;
            applyBtn.classList.remove('loading');
            self.showToast('Application submitted successfully!', 'success');
        }, 1500);
    });
};

ViewJobs.prototype.setupTableInteractions = function() {
    var self = this;
    
    // Add row selection
    document.addEventListener('click', function(e) {
        var row = e.target.closest('.job-row, .recommended-job-row');
        if (!row || e.target.tagName === 'A' || e.target.tagName === 'BUTTON') return;
        
        // Clear previous selection
        var allRows = document.querySelectorAll('.job-row, .recommended-job-row');
        for (var i = 0; i < allRows.length; i++) {
            allRows[i].classList.remove('selected');
        }
        
        // Select current row
        row.classList.add('selected');
        
        // Show quick actions
        self.showQuickActions(row);
    });
};

ViewJobs.prototype.showQuickActions = function(row) {
    // This could show a context menu or quick action bar
    console.log('Selected row:', row);
};

ViewJobs.prototype.setupKeyboardNavigation = function() {
    var self = this;
    
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + F: Focus search
        if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
            e.preventDefault();
            var searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.focus();
                searchInput.select();
            }
        }
        
        // Ctrl/Cmd + S: Save selected job
        if ((e.ctrlKey || e.metaKey) && e.key === 's') {
            e.preventDefault();
            var selectedRow = document.querySelector('.job-row.selected, .recommended-job-row.selected');
            if (selectedRow) {
                var saveBtn = selectedRow.querySelector('.btn-save');
                if (saveBtn) saveBtn.click();
            }
        }
        
        // Escape: Clear filters
        if (e.key === 'Escape') {
            self.clearAllFilters();
        }
    });
};

ViewJobs.prototype.setupTooltips = function() {
    var self = this;
    
    // Simple tooltip implementation
    document.addEventListener('mouseover', function(e) {
        var target = e.target.closest('[data-tooltip]');
        if (!target) return;
        
        var tooltip = document.createElement('div');
        tooltip.className = 'tooltip';
        tooltip.textContent = target.dataset.tooltip;
        document.body.appendChild(tooltip);
        
        var rect = target.getBoundingClientRect();
        tooltip.style.position = 'fixed';
        tooltip.style.top = (rect.top - tooltip.offsetHeight - 10) + 'px';
        tooltip.style.left = (rect.left + rect.width / 2 - tooltip.offsetWidth / 2) + 'px';
        tooltip.style.background = 'var(--dark)';
        tooltip.style.color = 'white';
        tooltip.style.padding = '6px 12px';
        tooltip.style.borderRadius = '4px';
        tooltip.style.fontSize = '0.85rem';
        tooltip.style.zIndex = '1000';
        tooltip.style.opacity = '0';
        
        setTimeout(function() {
            tooltip.style.transition = 'opacity 0.2s';
            tooltip.style.opacity = '1';
        }, 10);
        
        var removeTooltip = function() {
            tooltip.style.opacity = '0';
            setTimeout(function() {
                if (tooltip.parentNode) {
                    tooltip.remove();
                }
            }, 200);
            target.removeEventListener('mouseleave', removeTooltip);
            target.removeEventListener('click', removeTooltip);
        };
        
        target.addEventListener('mouseleave', removeTooltip);
        target.addEventListener('click', removeTooltip);
    });
};

ViewJobs.prototype.showToast = function(message, type) {
    type = type || 'info';
    
    if (typeof window.seekerDashboard !== 'undefined' && window.seekerDashboard.showToast) {
        window.seekerDashboard.showToast(message, type);
    } else {
        // Fallback toast
        var toast = document.createElement('div');
        toast.className = 'toast ' + type;
        
        var icon = 'info-circle';
        if (type === 'success') {
            icon = 'check-circle';
        } else if (type === 'error') {
            icon = 'exclamation-circle';
        } else if (type === 'warning') {
            icon = 'exclamation-triangle';
        }
        
        toast.innerHTML = '<i class="fas fa-' + icon + '"></i><span>' + this.escapeHtml(message) + '</span>';
        document.body.appendChild(toast);
        
        setTimeout(function() {
            if (toast.parentNode) {
                toast.remove();
            }
        }, 3000);
    }
};

ViewJobs.prototype.showLoading = function() {
    if (typeof window.seekerDashboard !== 'undefined' && window.seekerDashboard.showLoading) {
        window.seekerDashboard.showLoading();
    }
};

ViewJobs.prototype.hideLoading = function() {
    if (typeof window.seekerDashboard !== 'undefined' && window.seekerDashboard.hideLoading) {
        window.seekerDashboard.hideLoading();
    }
};

ViewJobs.prototype.escapeHtml = function(text) {
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    window.viewJobsApp = new ViewJobs();
});