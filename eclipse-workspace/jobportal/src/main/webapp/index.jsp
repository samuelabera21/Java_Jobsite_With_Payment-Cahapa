<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JobPortal — Find Your Dream Job</title>
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* ===== CSS Reset ===== */
        * { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --secondary: #7c3aed;
            --accent: #06b6d4;
            --light: #f8fafc;
            --dark: #1e293b;
            --text: #334155;
            --text-light: #64748b;
            --bg: #ffffff;
            --card-bg: #ffffff;
            --nav-bg: rgba(255, 255, 255, 0.95);
            --shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            --shadow-hover: 0 20px 40px rgba(0, 0, 0, 0.1);
            --radius: 12px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body.dark {
            --primary: #3b82f6;
            --primary-dark: #2563eb;
            --light: #0f172a;
            --dark: #f1f5f9;
            --text: #cbd5e1;
            --text-light: #94a3b8;
            --bg: #0f172a;
            --card-bg: #1e293b;
            --nav-bg: rgba(15, 23, 42, 0.95);
            --shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            --shadow-hover: 0 20px 40px rgba(0, 0, 0, 0.3);
        }

        body {
            font-family: 'Inter', 'Poppins', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            transition: var(--transition);
            overflow-x: hidden;
            line-height: 1.6;
        }

        /* ===== Typography ===== */
        h1, h2, h3, h4, h5, h6 {
            font-weight: 700;
            line-height: 1.2;
            margin-bottom: 1rem;
        }

        h1 { font-size: clamp(2.5rem, 5vw, 4rem); }
        h2 { font-size: clamp(2rem, 4vw, 3rem); }
        h3 { font-size: clamp(1.5rem, 3vw, 2rem); }

        /* ===== Language Toggle ===== */
        .language-toggle {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-right: 20px;
            cursor: pointer;
            padding: 8px 16px;
            border-radius: 20px;
            background: rgba(37, 99, 235, 0.1);
            color: var(--primary);
            font-weight: 500;
            transition: var(--transition);
        }

        .language-toggle:hover {
            background: rgba(37, 99, 235, 0.2);
            transform: translateY(-2px);
        }

        /* ===== Navigation ===== */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            padding: 1rem 5%;
            background: var(--nav-bg);
            backdrop-filter: blur(10px);
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            transform: translateY(0);
            transition: var(--transition);
        }

        .navbar.scrolled {
            padding: 0.75rem 5%;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--primary);
            text-decoration: none;
        }

        .logo i {
            font-size: 2rem;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--text);
            font-weight: 500;
            font-size: 1rem;
            position: relative;
            padding: 0.5rem 0;
            transition: var(--transition);
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--primary);
            transition: var(--transition);
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .nav-links a:hover::after {
            width: 100%;
        }

        .cta-buttons {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .theme-toggle {
            background: none;
            border: none;
            font-size: 1.25rem;
            cursor: pointer;
            color: var(--text);
            padding: 8px;
            border-radius: 50%;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .theme-toggle:hover {
            background: var(--card-bg);
            transform: rotate(15deg);
        }

        /* ===== Hero Section ===== */
        .hero-section {
            min-height: 100vh;
            position: relative;
            display: flex;
            align-items: center;
            padding: 120px 5% 80px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.95) 0%, rgba(37, 99, 235, 0.8) 100%);
        }

        .hero-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            z-index: -2;
            opacity: 0.5;
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, 
                rgba(15, 23, 42, 0.8) 0%, 
                rgba(37, 99, 235, 0.6) 50%, 
                rgba(124, 58, 237, 0.4) 100%);
            z-index: -1;
        }

        .hero-content {
            max-width: 800px;
            animation: fadeUp 1s ease-out;
            position: relative;
            z-index: 1;
        }

        .hero-content h1 {
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, #ffffff 0%, #cbd5e1 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-content p {
            font-size: 1.25rem;
            color: #e2e8f0;
            margin-bottom: 2.5rem;
            max-width: 600px;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        /* ===== Buttons ===== */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 1rem 2rem;
            border-radius: var(--radius);
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            border: 2px solid transparent;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(37, 99, 235, 0.3);
        }

        .btn-secondary {
            background: transparent;
            color: white;
            border-color: rgba(255, 255, 255, 0.3);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-3px);
        }

        .btn-outline {
            background: transparent;
            color: var(--primary);
            border-color: var(--primary);
        }

        .btn-outline:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-3px);
        }

        /* ===== Sections ===== */
        .section {
            padding: 80px 5%;
        }

        .section-title {
            text-align: center;
            margin-bottom: 3rem;
        }

        .section-title .subtitle {
            color: var(--primary);
            font-weight: 600;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 0.5rem;
        }

        /* ===== Features Section ===== */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .feature-card {
            background: var(--card-bg);
            padding: 2.5rem 2rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            transition: var(--transition);
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-hover);
        }

        .feature-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 1.75rem;
            color: white;
        }

        /* ===== About Section ===== */
        .about-section {
            background: linear-gradient(135deg, var(--card-bg) 0%, rgba(37, 99, 235, 0.05) 100%);
        }

        .about-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 4rem;
            align-items: center;
        }

        .about-image {
            position: relative;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        .about-image img {
            width: 100%;
            height: auto;
            transition: var(--transition);
        }

        .about-image:hover img {
            transform: scale(1.05);
        }

        /* ===== Testimonials ===== */
        .testimonials-section {
            background: var(--card-bg);
        }

        .testimonials-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .testimonial-card {
            background: var(--bg);
            padding: 2rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            position: relative;
            transition: var(--transition);
        }

        .testimonial-card:hover {
            transform: translateY(-5px);
        }

        .testimonial-text {
            font-style: italic;
            margin-bottom: 1.5rem;
            position: relative;
            padding-left: 1.5rem;
        }

        .testimonial-text::before {
            content: '"';
            position: absolute;
            left: 0;
            top: -10px;
            font-size: 3rem;
            color: var(--primary);
            opacity: 0.3;
        }

        .testimonial-author {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .author-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        /* ===== Stats Section ===== */
        .stats-section {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 80px 5%;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            text-align: center;
        }

        .stat-item {
            padding: 2rem;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            display: block;
        }

        /* ===== Contact Section ===== */
        .contact-section {
            background: var(--bg);
        }

        .contact-form {
            max-width: 600px;
            margin: 0 auto;
            padding: 2rem;
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text);
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 1rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: var(--radius);
            background: var(--bg);
            color: var(--text);
            font-family: inherit;
            transition: var(--transition);
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        /* ===== Footer ===== */
        .footer {
            background: var(--dark);
            color: var(--light);
            padding: 80px 5% 40px;
            margin-top: 80px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 3rem;
            margin-bottom: 3rem;
        }

        .footer-logo {
            font-size: 1.75rem;
            font-weight: 800;
            color: white;
            margin-bottom: 1rem;
        }

        .footer-links h3,
        .footer-contact h3 {
            color: white;
            margin-bottom: 1.5rem;
            font-size: 1.25rem;
        }

        .footer-links ul {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 0.75rem;
        }

        .footer-links a {
            color: #cbd5e1;
            text-decoration: none;
            transition: var(--transition);
        }

        .footer-links a:hover {
            color: var(--primary);
            padding-left: 5px;
        }

        .social-links {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .social-links a {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-decoration: none;
            transition: var(--transition);
        }

        .social-links a:hover {
            background: var(--primary);
            transform: translateY(-3px);
        }

        .copyright {
            text-align: center;
            padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #94a3b8;
        }

        /* ===== Animations ===== */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }

        /* ===== Responsive Design ===== */
        @media (max-width: 1024px) {
            .nav-links {
                display: none;
            }
            
            .mobile-menu-btn {
                display: block;
            }
        }

        @media (max-width: 768px) {
            .section {
                padding: 60px 5%;
            }
            
            .hero-content {
                text-align: center;
            }
            
            .hero-buttons {
                justify-content: center;
            }
            
            .btn {
                padding: 0.875rem 1.5rem;
            }
            
            .features-grid,
            .testimonials-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            .navbar {
                padding: 1rem;
            }
            
            .cta-buttons {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .hero-section {
                padding: 100px 5% 60px;
            }
            
            .hero-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .hero-buttons .btn {
                width: 100%;
                max-width: 300px;
            }
        }

        /* ===== Mobile Menu ===== */
        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--text);
            cursor: pointer;
            padding: 0.5rem;
        }

        @media (max-width: 1024px) {
            .mobile-menu-btn {
                display: block;
            }
            
            .mobile-menu {
                position: fixed;
                top: 80px;
                left: 0;
                right: 0;
                background: var(--nav-bg);
                backdrop-filter: blur(20px);
                padding: 2rem;
                display: flex;
                flex-direction: column;
                gap: 1rem;
                transform: translateY(-100%);
                opacity: 0;
                transition: var(--transition);
                z-index: 999;
            }
            
            .mobile-menu.active {
                transform: translateY(0);
                opacity: 1;
            }
        }

        /* ===== Amharic Font Support ===== */
        @font-face {
            font-family: 'Ethiopia Jiret';
            src: url('https://fonts.cdnfonts.com/css/ethiopia-jiret');
        }

        .amharic {
            font-family: 'Ethiopia Jiret', 'Poppins', sans-serif;
            direction: ltr;
        }

        /* ===== Floating Elements ===== */
        .floating-element {
            position: absolute;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            opacity: 0.1;
            animation: float 20s infinite ease-in-out;
            z-index: -1;
        }

        .floating-element:nth-child(1) {
            width: 300px;
            height: 300px;
            top: 10%;
            left: 5%;
            animation-delay: 0s;
        }

        .floating-element:nth-child(2) {
            width: 200px;
            height: 200px;
            bottom: 20%;
            right: 10%;
            animation-delay: -5s;
        }

        .floating-element:nth-child(3) {
            width: 150px;
            height: 150px;
            top: 40%;
            right: 20%;
            animation-delay: -10s;
        }
    </style>
</head>

<body>
    <!-- Floating Background Elements -->
    <div class="floating-element"></div>
    <div class="floating-element"></div>
    <div class="floating-element"></div>

    <!-- Navigation -->
    <nav class="navbar">
        <a href="#" class="logo">
            <i class="fas fa-briefcase"></i>
            JobPortal
        </a>

        <div class="nav-links">
            <a href="#home">Home</a>
            <a href="#features">Features</a>
            <a href="#about">About</a>
            <a href="#testimonials">Testimonials</a>
            <a href="#stats">Stats</a>
            <a href="#contact">Contact</a>
        </div>

        <div class="cta-buttons">
            <div class="language-toggle" id="languageToggle">
                <i class="fas fa-globe"></i>
                <span>English</span>
            </div>
            <a href="<%= request.getContextPath() %>/views/auth/login.jsp" class="btn btn-outline">Login</a>
            <a href="<%= request.getContextPath() %>/views/auth/register.jsp" class="btn btn-primary">Register</a>
            <button class="theme-toggle" id="themeToggle">
                <i class="fas fa-moon"></i>
            </button>
        </div>

        <button class="mobile-menu-btn" id="mobileMenuBtn">
            <i class="fas fa-bars"></i>
        </button>
    </nav>

    <!-- Mobile Menu -->
    <div class="mobile-menu" id="mobileMenu">
        <a href="#home">Home</a>
        <a href="#features">Features</a>
        <a href="#about">About</a>
        <a href="#testimonials">Testimonials</a>
        <a href="#stats">Stats</a>
        <a href="#contact">Contact</a>
        <a href="<%= request.getContextPath() %>/views/auth/login.jsp" class="btn btn-outline">Login</a>
        <a href="<%= request.getContextPath() %>/views/auth/register.jsp" class="btn btn-primary">Register</a>
    </div>

    <!-- Hero Section -->
    <section class="hero-section" id="home">
        <!-- Background Image -->
        <div class="hero-image" style="background-image: url('https://images.unsplash.com/photo-1497366754035-f200968a6e72?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');"></div>
        
        <!-- Gradient Overlay -->
        <div class="hero-overlay"></div>
        
        <div class="hero-content">
            <h1 id="heroTitle">Find Your Dream Job or Hire Top Talent</h1>
            <p id="heroSubtitle">The all-in-one platform connecting job seekers with employers worldwide. Start your journey today!</p>
            <div class="hero-buttons">
                <a href="<%= request.getContextPath() %>/views/auth/register.jsp?type=jobseeker" class="btn btn-primary">
                    <i class="fas fa-search"></i> Find Jobs
                </a>
                <a href="<%= request.getContextPath() %>/views/auth/register.jsp?type=employer" class="btn btn-secondary">
                    <i class="fas fa-building"></i> Post Jobs
                </a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="section" id="features">
        <div class="section-title">
            <span class="subtitle">Why Choose Us</span>
            <h2 id="featuresTitle">Our Powerful Features</h2>
        </div>

        <div class="features-grid">
            <div class="feature-card" data-aos="fade-up">
                <div class="feature-icon">
                    <i class="fas fa-search"></i>
                </div>
                <h3 id="feature1Title">Smart Job Search</h3>
                <p id="feature1Desc">Advanced filters and AI-powered recommendations to find your perfect match.</p>
            </div>

            <div class="feature-card" data-aos="fade-up" data-aos-delay="100">
                <div class="feature-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h3 id="feature2Title">Professional CV Builder</h3>
                <p id="feature2Desc">Create stunning resumes with our drag-and-drop builder and templates.</p>
            </div>

            <div class="feature-card" data-aos="fade-up" data-aos-delay="200">
                <div class="feature-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3 id="feature3Title">Analytics Dashboard</h3>
                <p id="feature3Desc">Track applications, profile views, and get insights to improve your chances.</p>
            </div>

            <div class="feature-card" data-aos="fade-up" data-aos-delay="300">
                <div class="feature-icon">
                    <i class="fas fa-comments"></i>
                </div>
                <h3 id="feature4Title">Direct Messaging</h3>
                <p id="feature4Desc">Communicate directly with employers without leaving the platform.</p>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section class="section about-section" id="about">
        <div class="section-title">
            <span class="subtitle">About Us</span>
            <h2 id="aboutTitle">Transforming Careers Since 2018</h2>
        </div>

        <div class="about-content">
            <div class="about-text">
                <h3 id="aboutSubtitle">Your Journey to Success Starts Here</h3>
                <p id="aboutDesc1">JobPortal is more than just a job board - we're a career growth platform that connects talented professionals with forward-thinking companies.</p>
                <p id="aboutDesc2">With over 50,000 successful placements and 10,000+ company partners, we've revolutionized how people find meaningful work.</p>
                <a href="#contact" class="btn btn-primary">Learn More</a>
            </div>
            <div class="about-image">
                <img src="https://images.unsplash.com/photo-1521737711867-e3b97375f902?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" alt="Our Team">
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section" id="stats">
        <div class="section-title">
            <h2 style="color: white;" id="statsTitle">Our Impact in Numbers</h2>
        </div>

        <div class="stats-grid">
            <div class="stat-item">
                <span class="stat-number" data-count="50000">0</span>
                <span id="stat1Label">Jobs Posted</span>
            </div>
            <div class="stat-item">
                <span class="stat-number" data-count="25000">0</span>
                <span id="stat2Label">Successful Hires</span>
            </div>
            <div class="stat-item">
                <span class="stat-number" data-count="10000">0</span>
                <span id="stat3Label">Company Partners</span>
            </div>
            <div class="stat-item">
                <span class="stat-number" data-count="98">0</span>
                <span id="stat4Label">Success Rate</span>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="section testimonials-section" id="testimonials">
        <div class="section-title">
            <span class="subtitle">Success Stories</span>
            <h2 id="testimonialsTitle">What Our Users Say</h2>
        </div>

        <div class="testimonials-grid">
            <div class="testimonial-card">
                <div class="testimonial-text" id="testimonial1">
                    "Found my dream job in just 2 weeks! The platform made the entire process seamless."
                </div>
                <div class="testimonial-author">
                    <div class="author-avatar">AS</div>
                    <div>
                        <h4>Abel Seifu</h4>
                        <p>Software Engineer at TechCorp</p>
                    </div>
                </div>
            </div>

            <div class="testimonial-card">
                <div class="testimonial-text" id="testimonial2">
                    "As an employer, the quality of candidates we found here was exceptional. Highly recommend!"
                </div>
                <div class="testimonial-author">
                    <div class="author-avatar">MS</div>
                    <div>
                        <h4>Meron Solomon</h4>
                        <p>HR Director at Innovate Ltd</p>
                    </div>
                </div>
            </div>

            <div class="testimonial-card">
                <div class="testimonial-text" id="testimonial3">
                    "The CV builder alone is worth it! My application rate increased by 300% after using it."
                </div>
                <div class="testimonial-author">
                    <div class="author-avatar">TA</div>
                    <div>
                        <h4>Tigist Abebe</h4>
                        <p>Marketing Specialist</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="section contact-section" id="contact">
        <div class="section-title">
            <span class="subtitle">Get In Touch</span>
            <h2 id="contactTitle">Contact Us</h2>
        </div>

        <div class="contact-form">
            <form id="contactForm">
                <div class="form-group">
                    <label for="name" id="nameLabel">Full Name</label>
                    <input type="text" id="name" required>
                </div>
                <div class="form-group">
                    <label for="email" id="emailLabel">Email Address</label>
                    <input type="email" id="email" required>
                </div>
                <div class="form-group">
                    <label for="subject" id="subjectLabel">Subject</label>
                    <input type="text" id="subject" required>
                </div>
                <div class="form-group">
                    <label for="message" id="messageLabel">Message</label>
                    <textarea id="message" rows="5" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <i class="fas fa-paper-plane"></i> Send Message
                </button>
            </form>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-about">
                <div class="footer-logo">
                    <i class="fas fa-briefcase"></i> JobPortal
                </div>
                <p id="footerAbout">Connecting talent with opportunity since 2018. Your career journey starts here.</p>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                </div>
            </div>

            <div class="footer-links">
                <h3 id="quickLinksTitle">Quick Links</h3>
                <ul>
                    <li><a href="#home">Home</a></li>
                    <li><a href="#features">Features</a></li>
                    <li><a href="#about">About Us</a></li>
                    <li><a href="#testimonials">Testimonials</a></li>
                    <li><a href="#contact">Contact</a></li>
                </ul>
            </div>

            <div class="footer-contact">
                <h3 id="contactInfoTitle">Contact Info</h3>
                <p><i class="fas fa-map-marker-alt"></i> Addis Ababa, Ethiopia</p>
                <p><i class="fas fa-phone"></i> +251 911 234 567</p>
                <p><i class="fas fa-envelope"></i> info@jobportal.et</p>
            </div>
        </div>

        <div class="copyright">
            <p>&copy; 2025 JobPortal. <span id="rightsText">All rights reserved.</span></p>
        </div>
    </footer>

    <script>
        // ===== Enhanced JavaScript with Animations and Functionality =====
        
        // Language support (English/Amharic)
        const translations = {
            en: {
                heroTitle: "Find Your Dream Job or Hire Top Talent",
                heroSubtitle: "The all-in-one platform connecting job seekers with employers worldwide. Start your journey today!",
                featuresTitle: "Our Powerful Features",
                feature1Title: "Smart Job Search",
                feature1Desc: "Advanced filters and AI-powered recommendations to find your perfect match.",
                feature2Title: "Professional CV Builder",
                feature2Desc: "Create stunning resumes with our drag-and-drop builder and templates.",
                feature3Title: "Analytics Dashboard",
                feature3Desc: "Track applications, profile views, and get insights to improve your chances.",
                feature4Title: "Direct Messaging",
                feature4Desc: "Communicate directly with employers without leaving the platform.",
                aboutTitle: "Transforming Careers Since 2018",
                aboutSubtitle: "Your Journey to Success Starts Here",
                aboutDesc1: "JobPortal is more than just a job board - we're a career growth platform that connects talented professionals with forward-thinking companies.",
                aboutDesc2: "With over 50,000 successful placements and 10,000+ company partners, we've revolutionized how people find meaningful work.",
                statsTitle: "Our Impact in Numbers",
                stat1Label: "Jobs Posted",
                stat2Label: "Successful Hires",
                stat3Label: "Company Partners",
                stat4Label: "Success Rate",
                testimonialsTitle: "What Our Users Say",
                testimonial1: "\"Found my dream job in just 2 weeks! The platform made the entire process seamless.\"",
                testimonial2: "\"As an employer, the quality of candidates we found here was exceptional. Highly recommend!\"",
                testimonial3: "\"The CV builder alone is worth it! My application rate increased by 300% after using it.\"",
                contactTitle: "Contact Us",
                nameLabel: "Full Name",
                emailLabel: "Email Address",
                subjectLabel: "Subject",
                messageLabel: "Message",
                submitBtn: "Send Message",
                footerAbout: "Connecting talent with opportunity since 2018. Your career journey starts here.",
                quickLinksTitle: "Quick Links",
                contactInfoTitle: "Contact Info",
                rightsText: "All rights reserved.",
                language: "Amharic"
            },
            am: {
                heroTitle: "የህልምዎን ስራ ይፈልጉ ወይም ምርጥ ተዓዛባዮችን ይቅጠሩ",
                heroSubtitle: "የሥራ ፈላጊዎችን ከዓለም ዙሪያ ከሥራ ሰጭዎች ጋር የሚያገናኝ ሁሉን-በአንድ የሚያካትት መድረክ። ጉዞዎን ዛሬ ይጀምሩ!",
                featuresTitle: "የእኛ ኃያል ባህሪያት",
                feature1Title: "ብልጠት ያለው የስራ ፍለጋ",
                feature1Desc: "ፍጹም ተስማሚዎን ለማግኘት የላቀ ማጣሪያዎች እና በ AI የሚመራ ምክሮች።",
                feature2Title: "የፕሮፌሽናል CV ገንቢ",
                feature2Desc: "ከተጎተት-እና-ጣል ገንቢ እና አብነቶቻችን ጋር አስደናቂ ሪዝሜዎችን ይፍጠሩ።",
                feature3Title: "የትንታኔ ዳሽቦርድ",
                feature3Desc: "የመማጠቂያዎችን፣ የመገለጫ እይታዎችን ይከታተሉ እና ዕድሎችዎን ለማሻሻል ግንዛቤዎችን ያግኙ።",
                feature4Title: "ቀጥተኛ መልዕክት",
                feature4Desc: "ከመድረኩ ያለመውጣት ከሥራ ሰጭዎች ጋር በቀጥታ ይገናኙ።",
                aboutTitle: "ከ2018 ጀምሮ ሙያዎችን በመቀየር ላይ",
                aboutSubtitle: "የእርስዎ ወደ ስኬት ጉዞ እዚህ ይጀምራል",
                aboutDesc1: "JobPortal ከስራ ሰሌዳ በላይ ነው - ብቃት ያላቸው ፕሮፌሽናሎችን ከፊት ለፊት ካሉ ኩባንያዎች ጋር የሚያገናኝ የሙያ እድገት መድረክ ነን።",
                aboutDesc2: "ከ50,000 በላይ የሚሆኑ የተሳካ ምደባዎች እና ከ10,000+ የኩባንያ አጋሮች ጋር ሰዎች ትርጉም ያለው ስራ እንዴት እንደሚያገኙ አብዮት አድርገናል።",
                statsTitle: "ቁጥሮቻችን ውስጥ የኛ ተጽዕኖ",
                stat1Label: "የተለጠፉ ስራዎች",
                stat2Label: "የተሳኩ ቅጥሮች",
                stat3Label: "የኩባንያ አጋሮች",
                stat4Label: "የስኬት መጠን",
                testimonialsTitle: "ተጠቃሚዎቻችን ምን ይላሉ",
                testimonial1: "\"የህልሜን ስራ በ2 ሳምንት ብቻ አገኘሁ! መድረኩ አጠቃላይ ሂደቱን ሳይለያይ አደረገው።\"",
                testimonial2: "\"እንደ ሥራ ሰጭ፣ እዚህ ያገኘነው የሚፈለጉ ተመራጮች ልዩ ነበር። በከፍተኛ ደረጃ እመክራለሁ!\"",
                testimonial3: "\"CV ገንቢው ብቻውንም ዋጋ ያለው ነው! ከመጠቀሜ በኋላ የመማጠቂያ መጠኔ በ300% ጨምሯል።\"",
                contactTitle: "አግኙን",
                nameLabel: "ሙሉ ስም",
                emailLabel: "የኢሜል አድራሻ",
                subjectLabel: "ርዕስ",
                messageLabel: "መልእክት",
                submitBtn: "መልእክት ይላኩ",
                footerAbout: "ከ2018 ጀምሮ ብቃት ከመደሰት ጋር በማገናኘት። የእርስዎ የሙያ ጉዞ እዚህ ይጀምራል።",
                quickLinksTitle: "ፈጣን አገናኞች",
                contactInfoTitle: "የመገኛ መረጃ",
                rightsText: "ሁሉም መብቶች የተጠበቁ ናቸው።",
                language: "English"
            }
        };

        let currentLang = 'en';

        // Theme toggle
        const themeToggle = document.getElementById('themeToggle');
        const themeIcon = themeToggle.querySelector('i');

        // Mobile menu toggle
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const mobileMenu = document.getElementById('mobileMenu');

        // Language toggle
        const languageToggle = document.getElementById('languageToggle');
        const languageText = languageToggle.querySelector('span');

        // Contact form
        const contactForm = document.getElementById('contactForm');

        // ===== Initialize Functions =====
        function init() {
            // Initialize theme
            if (localStorage.getItem('theme') === 'dark') {
                document.body.classList.add('dark');
                themeIcon.className = 'fas fa-sun';
            }

            // Initialize animations
            initAnimations();
            
            // Initialize stats counter
            initStatsCounter();
            
            // Initialize scroll effects
            initScrollEffects();
            
            // Initialize event listeners
            initEventListeners();
        }

        // ===== Animation Functions =====
        function initAnimations() {
            // Animate elements on scroll
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animation = 'fadeUp 0.6s ease-out forwards';
                        entry.target.style.opacity = '1';
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });

            // Observe all feature cards and testimonials
            document.querySelectorAll('.feature-card, .testimonial-card, .about-content, .stat-item').forEach(el => {
                el.style.opacity = '0';
                observer.observe(el);
            });
        }

        function initStatsCounter() {
            const statNumbers = document.querySelectorAll('.stat-number');
            
            statNumbers.forEach(stat => {
                const target = parseInt(stat.getAttribute('data-count'));
                const suffix = stat.textContent.includes('%') ? '%' : '+';
                let count = 0;
                const increment = target / 50;
                
                const updateCount = () => {
                    if (count < target) {
                        count += increment;
                        stat.textContent = Math.floor(count) + suffix;
                        setTimeout(updateCount, 30);
                    } else {
                        stat.textContent = target + suffix;
                    }
                };
                
                // Start counting when element is in view
                const observer = new IntersectionObserver((entries) => {
                    if (entries[0].isIntersecting) {
                        updateCount();
                        observer.disconnect();
                    }
                });
                
                observer.observe(stat);
            });
        }

        function initScrollEffects() {
            // Navbar scroll effect
            window.addEventListener('scroll', () => {
                const navbar = document.querySelector('.navbar');
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
                
                // Parallax effect for hero
                const scrolled = window.pageYOffset;
                const hero = document.querySelector('.hero-section');
                hero.style.transform = `translateY(${scrolled * 0.05}px)`;
            });
        }

        // ===== Event Listeners =====
        function initEventListeners() {
            // Theme toggle
            themeToggle.addEventListener('click', () => {
                document.body.classList.toggle('dark');
                const isDark = document.body.classList.contains('dark');
                themeIcon.className = isDark ? 'fas fa-sun' : 'fas fa-moon';
                localStorage.setItem('theme', isDark ? 'dark' : 'light');
            });

            // Mobile menu toggle
            mobileMenuBtn.addEventListener('click', () => {
                mobileMenu.classList.toggle('active');
                const icon = mobileMenuBtn.querySelector('i');
                icon.className = mobileMenu.classList.contains('active') ? 'fas fa-times' : 'fas fa-bars';
            });

            // Close mobile menu when clicking outside
            document.addEventListener('click', (e) => {
                if (!mobileMenu.contains(e.target) && !mobileMenuBtn.contains(e.target)) {
                    mobileMenu.classList.remove('active');
                    mobileMenuBtn.querySelector('i').className = 'fas fa-bars';
                }
            });

            // Language toggle
            languageToggle.addEventListener('click', () => {
                currentLang = currentLang === 'en' ? 'am' : 'en';
                updateLanguage(currentLang);
            });

            // Smooth scroll for anchor links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function(e) {
                    e.preventDefault();
                    const targetId = this.getAttribute('href');
                    if (targetId === '#') return;
                    
                    const targetElement = document.querySelector(targetId);
                    if (targetElement) {
                        // Close mobile menu if open
                        mobileMenu.classList.remove('active');
                        mobileMenuBtn.querySelector('i').className = 'fas fa-bars';
                        
                        // Smooth scroll to target
                        targetElement.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            // Contact form submission
            if (contactForm) {
                contactForm.addEventListener('submit', (e) => {
                    e.preventDefault();
                    
                    // Get form data
                    const formData = new FormData(contactForm);
                    const data = Object.fromEntries(formData);
                    
                    // Show success message
                    const submitBtn = contactForm.querySelector('#submitBtn');
                    const originalText = submitBtn.innerHTML;
                    
                    submitBtn.innerHTML = '<i class="fas fa-check"></i> Message Sent!';
                    submitBtn.disabled = true;
                    
                    // Reset after 3 seconds
                    setTimeout(() => {
                        contactForm.reset();
                        submitBtn.innerHTML = originalText;
                        submitBtn.disabled = false;
                    }, 3000);
                });
            }

            // Add hover effects to cards
            document.querySelectorAll('.feature-card, .testimonial-card').forEach(card => {
                card.addEventListener('mouseenter', () => {
                    card.style.transform = 'translateY(-10px) scale(1.02)';
                });
                
                card.addEventListener('mouseleave', () => {
                    card.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Add typing effect to hero subtitle
            const heroSubtitle = document.getElementById('heroSubtitle');
            const originalText = heroSubtitle.textContent;
            let charIndex = 0;
            
            function typeWriter() {
                if (charIndex < originalText.length) {
                    heroSubtitle.textContent = originalText.substring(0, charIndex + 1);
                    charIndex++;
                    setTimeout(typeWriter, 30);
                }
            }
            
            // Start typing effect after 1 second
            setTimeout(typeWriter, 1000);
        }

        // ===== Language Functions =====
        function updateLanguage(lang) {
            currentLang = lang;
            const t = translations[lang];
            
            // Update all translatable elements
            document.getElementById('heroTitle').textContent = t.heroTitle;
            document.getElementById('heroSubtitle').textContent = t.heroSubtitle;
            document.getElementById('featuresTitle').textContent = t.featuresTitle;
            document.getElementById('feature1Title').textContent = t.feature1Title;
            document.getElementById('feature1Desc').textContent = t.feature1Desc;
            document.getElementById('feature2Title').textContent = t.feature2Title;
            document.getElementById('feature2Desc').textContent = t.feature2Desc;
            document.getElementById('feature3Title').textContent = t.feature3Title;
            document.getElementById('feature3Desc').textContent = t.feature3Desc;
            document.getElementById('feature4Title').textContent = t.feature4Title;
            document.getElementById('feature4Desc').textContent = t.feature4Desc;
            document.getElementById('aboutTitle').textContent = t.aboutTitle;
            document.getElementById('aboutSubtitle').textContent = t.aboutSubtitle;
            document.getElementById('aboutDesc1').textContent = t.aboutDesc1;
            document.getElementById('aboutDesc2').textContent = t.aboutDesc2;
            document.getElementById('statsTitle').textContent = t.statsTitle;
            document.getElementById('stat1Label').textContent = t.stat1Label;
            document.getElementById('stat2Label').textContent = t.stat2Label;
            document.getElementById('stat3Label').textContent = t.stat3Label;
            document.getElementById('stat4Label').textContent = t.stat4Label;
            document.getElementById('testimonialsTitle').textContent = t.testimonialsTitle;
            document.getElementById('testimonial1').textContent = t.testimonial1;
            document.getElementById('testimonial2').textContent = t.testimonial2;
            document.getElementById('testimonial3').textContent = t.testimonial3;
            document.getElementById('contactTitle').textContent = t.contactTitle;
            document.getElementById('nameLabel').textContent = t.nameLabel;
            document.getElementById('emailLabel').textContent = t.emailLabel;
            document.getElementById('subjectLabel').textContent = t.subjectLabel;
            document.getElementById('messageLabel').textContent = t.messageLabel;
            document.getElementById('submitBtn').innerHTML = `<i class="fas fa-paper-plane"></i> ${t.submitBtn}`;
            document.getElementById('footerAbout').textContent = t.footerAbout;
            document.getElementById('quickLinksTitle').textContent = t.quickLinksTitle;
            document.getElementById('contactInfoTitle').textContent = t.contactInfoTitle;
            document.getElementById('rightsText').textContent = t.rightsText;
            languageText.textContent = t.language;
            
            // Add Amharic font class
            if (lang === 'am') {
                document.body.classList.add('amharic');
            } else {
                document.body.classList.remove('amharic');
            }
            
            // Save language preference
            localStorage.setItem('language', lang);
        }

        // Load saved language preference
        const savedLang = localStorage.getItem('language') || 'en';
        updateLanguage(savedLang);

        // Initialize everything when DOM is loaded
        document.addEventListener('DOMContentLoaded', init);
    </script>
</body>
</html>