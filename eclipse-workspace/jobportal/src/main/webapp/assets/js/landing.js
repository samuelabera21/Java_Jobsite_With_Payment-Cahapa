// Enhanced landing.js with modern animations and effects

class LandingPageAnimations {
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
        // Setup all animations and event listeners
        this.setupSmoothScrolling();
        this.setupScrollAnimations();
        this.setupHoverEffects();
        this.setupParallaxEffects();
        this.setupCounters();
        this.setupIntersectionObservers();
        this.setupFormAnimations();
    }

    setupSmoothScrolling() {
        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', (e) => {
                e.preventDefault();
                const targetId = anchor.getAttribute('href');
                if (targetId === '#') return;
                
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    const headerOffset = 80;
                    const elementPosition = targetElement.getBoundingClientRect().top;
                    const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                    window.scrollTo({
                        top: offsetPosition,
                        behavior: 'smooth'
                    });
                }
            });
        });
    }

    setupScrollAnimations() {
        // Fade in elements on scroll
        const fadeElements = document.querySelectorAll('.fade-in, .fade-in-delayed, .slide-up');
        
        const fadeObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    
                    // Add staggered animation
                    const delay = entry.target.classList.contains('fade-in-delayed') ? 300 : 0;
                    setTimeout(() => {
                        entry.target.style.animation = entry.target.classList.contains('slide-up') 
                            ? 'slideUp 0.8s ease forwards' 
                            : 'fadeIn 0.6s ease forwards';
                    }, delay);
                }
            });
        }, { threshold: 0.1 });

        fadeElements.forEach(el => {
            el.style.opacity = '0';
            fadeObserver.observe(el);
        });

        // Navbar scroll effect
        let lastScrollTop = 0;
        const navbar = document.querySelector('.navbar');

        window.addEventListener('scroll', () => {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
            
            if (scrollTop > 100) {
                navbar.classList.add('scrolled');
                
                // Hide navbar on scroll down, show on scroll up
                if (scrollTop > lastScrollTop && scrollTop > 200) {
                    navbar.style.transform = 'translateY(-100%)';
                } else {
                    navbar.style.transform = 'translateY(0)';
                }
            } else {
                navbar.classList.remove('scrolled');
                navbar.style.transform = 'translateY(0)';
            }
            
            lastScrollTop = scrollTop;
        });
    }

    setupHoverEffects() {
        // Card hover effects
        const cards = document.querySelectorAll('.card, .feature-card, .testimonial-card');
        
        cards.forEach(card => {
            card.addEventListener('mouseenter', (e) => {
                const cardRect = card.getBoundingClientRect();
                const x = e.clientX - cardRect.left;
                const y = e.clientY - cardRect.top;
                
                card.style.setProperty('--mouse-x', `${x}px`);
                card.style.setProperty('--mouse-y', `${y}px`);
                
                card.style.transform = 'translateY(-15px) scale(1.03)';
                card.style.boxShadow = '0 25px 50px rgba(0, 0, 0, 0.15)';
                
                // Add shine effect
                card.style.background = `radial-gradient(circle at var(--mouse-x) var(--mouse-y), 
                    rgba(255,255,255,0.1) 0%, 
                    transparent 50%)`;
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0) scale(1)';
                card.style.boxShadow = '';
                card.style.background = '';
            });
        });

        // Button hover effects
        const buttons = document.querySelectorAll('.btn');
        
        buttons.forEach(btn => {
            btn.addEventListener('mouseenter', (e) => {
                const btnRect = btn.getBoundingClientRect();
                const x = e.clientX - btnRect.left;
                const y = e.clientY - btnRect.top;
                
                btn.style.setProperty('--x', `${x}px`);
                btn.style.setProperty('--y', `${y}px`);
                
                btn.style.transform = 'translateY(-3px)';
            });
            
            btn.addEventListener('mouseleave', () => {
                btn.style.transform = 'translateY(0)';
            });
        });
    }

    setupParallaxEffects() {
        // Simple parallax for hero section
        const hero = document.querySelector('.hero-section');
        
        if (hero) {
            window.addEventListener('scroll', () => {
                const scrolled = window.pageYOffset;
                const rate = scrolled * -0.5;
                hero.style.transform = `translate3d(0, ${rate}px, 0)`;
            });
        }
    }

    setupCounters() {
        // Animated counters for statistics
        const counters = document.querySelectorAll('.stat-number');
        
        const counterObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const counter = entry.target;
                    const target = parseInt(counter.getAttribute('data-count') || counter.textContent);
                    const suffix = counter.textContent.includes('%') ? '%' : '';
                    const duration = 2000; // 2 seconds
                    const step = target / (duration / 16); // 60fps
                    let current = 0;
                    
                    const updateCounter = () => {
                        current += step;
                        if (current < target) {
                            counter.textContent = Math.floor(current) + suffix;
                            requestAnimationFrame(updateCounter);
                        } else {
                            counter.textContent = target + suffix;
                        }
                    };
                    
                    updateCounter();
                    counterObserver.unobserve(counter);
                }
            });
        }, { threshold: 0.5 });
        
        counters.forEach(counter => counterObserver.observe(counter));
    }

    setupIntersectionObservers() {
        // Setup observers for various animation triggers
        const sections = document.querySelectorAll('section');
        
        const sectionObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('in-view');
                    
                    // Add different animations based on section
                    const sectionId = entry.target.id;
                    switch(sectionId) {
                        case 'features':
                            this.animateFeatureCards(entry.target);
                            break;
                        case 'testimonials':
                            this.animateTestimonials(entry.target);
                            break;
                        case 'stats':
                            this.animateStats(entry.target);
                            break;
                    }
                }
            });
        }, { threshold: 0.2 });
        
        sections.forEach(section => sectionObserver.observe(section));
    }

    setupFormAnimations() {
        // Form input animations
        const formInputs = document.querySelectorAll('.form-group input, .form-group textarea');
        
        formInputs.forEach(input => {
            input.addEventListener('focus', () => {
                input.parentElement.classList.add('focused');
            });
            
            input.addEventListener('blur', () => {
                if (!input.value) {
                    input.parentElement.classList.remove('focused');
                }
            });
            
            // Check if input has value on page load
            if (input.value) {
                input.parentElement.classList.add('focused');
            }
        });
    }

    animateFeatureCards(section) {
        const cards = section.querySelectorAll('.feature-card');
        
        cards.forEach((card, index) => {
            setTimeout(() => {
                card.style.animation = `fadeUp 0.6s ease ${index * 0.1}s forwards`;
                card.style.opacity = '1';
            }, 100);
        });
    }

    animateTestimonials(section) {
        const testimonials = section.querySelectorAll('.testimonial-card');
        
        testimonials.forEach((testimonial, index) => {
            setTimeout(() => {
                testimonial.style.animation = `slideUp 0.8s ease ${index * 0.15}s forwards`;
                testimonial.style.opacity = '1';
            }, 200);
        });
    }

    animateStats(section) {
        const stats = section.querySelectorAll('.stat-item');
        
        stats.forEach((stat, index) => {
            setTimeout(() => {
                stat.style.animation = `fadeIn 0.5s ease ${index * 0.2}s forwards`;
                stat.style.opacity = '1';
            }, 300);
        });
    }

    // Utility function for creating particle effects
    createParticles(element, count = 30) {
        if (!element) return;
        
        for (let i = 0; i < count; i++) {
            const particle = document.createElement('div');
            particle.classList.add('particle');
            
            // Random size and position
            const size = Math.random() * 10 + 5;
            const x = Math.random() * 100;
            const y = Math.random() * 100;
            
            particle.style.width = `${size}px`;
            particle.style.height = `${size}px`;
            particle.style.left = `${x}%`;
            particle.style.top = `${y}%`;
            particle.style.background = `rgba(37, 99, 235, ${Math.random() * 0.3})`;
            particle.style.borderRadius = '50%';
            particle.style.position = 'absolute';
            particle.style.zIndex = '-1';
            particle.style.animation = `float ${Math.random() * 10 + 10}s infinite ease-in-out`;
            
            element.appendChild(particle);
        }
    }
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes floatParticle {
        0%, 100% { transform: translate(0, 0) rotate(0deg); }
        33% { transform: translate(10px, -20px) rotate(120deg); }
        66% { transform: translate(-15px, 10px) rotate(240deg); }
    }
    
    @keyframes shimmer {
        0% { background-position: -1000px 0; }
        100% { background-position: 1000px 0; }
    }
    
    .pulse {
        animation: pulse 2s infinite;
    }
    
    @keyframes pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.5; }
    }
    
    .shake {
        animation: shake 0.5s;
    }
    
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-5px); }
        75% { transform: translateX(5px); }
    }
`;

document.head.appendChild(style);

// Initialize animations
document.addEventListener('DOMContentLoaded', () => {
    new LandingPageAnimations();
    
    // Add particles to hero section
    const hero = document.querySelector('.hero-section');
    if (hero) {
        const animation = new LandingPageAnimations();
        animation.createParticles(hero, 20);
    }
});

// Handle form submissions with animations
document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        
        // Show loading animation
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
        submitBtn.disabled = true;
        
        // Simulate API call with setTimeout
        setTimeout(() => {
            // Show success animation
            submitBtn.innerHTML = '<i class="fas fa-check"></i> Success!';
            submitBtn.classList.add('pulse');
            
            // Reset after 2 seconds
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
                submitBtn.classList.remove('pulse');
                form.reset();
            }, 2000);
        }, 1500);
    });
});

// Add scroll progress indicator
const progressBar = document.createElement('div');
progressBar.style.position = 'fixed';
progressBar.style.top = '0';
progressBar.style.left = '0';
progressBar.style.height = '3px';
progressBar.style.background = 'linear-gradient(90deg, var(--primary), var(--secondary))';
progressBar.style.width = '0%';
progressBar.style.zIndex = '1001';
progressBar.style.transition = 'width 0.3s ease';
document.body.appendChild(progressBar);

window.addEventListener('scroll', () => {
    const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
    const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    const scrolled = (winScroll / height) * 100;
    progressBar.style.width = scrolled + '%';
});