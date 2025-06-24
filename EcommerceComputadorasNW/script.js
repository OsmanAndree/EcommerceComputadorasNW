// Sample product data
const products = [
  {
    id: 1,
    title: "Laptop Gaming ASUS ROG Strix G15",
    price: 1299.99,
    rating: 4.5,
    reviews: 234,
    image: "img/rogstrix.jpg",
    category: "gaming",
    brand: "asus",
    description: "Laptop gaming con RTX 4060, AMD Ryzen 7, 16GB RAM, 512GB SSD"
  },
  {
    id: 2,
    title: 'MacBook Pro 14" M3 Pro',
    price: 1999.99,
    rating: 4.8,
    reviews: 156,
    image: "img/macbookpro.jpg",
    category: "office",
    brand: "apple",
    description: "MacBook Pro con chip M3 Pro, 18GB RAM unificada, 512GB SSD"
  },
  {
    id: 3,
    title: "PC Gaming Custom RTX 4070",
    price: 1599.99,
    rating: 4.6,
    reviews: 89,
    image: "img/pccustom.jpg",
    category: "desktop",
    brand: "custom",
    description: "PC gaming personalizada con RTX 4070, Intel i7, 32GB RAM, 1TB NVMe"
  },
  {
    id: 4,
    title: "Laptop Dell XPS 13 Plus",
    price: 1199.99,
    rating: 4.4,
    reviews: 312,
    image: "img/dellxps.jpg",
    category: "office",
    brand: "dell",
    description: "Laptop ultrabook con Intel i7, 16GB RAM, 512GB SSD, pantalla 4K"
  },
  {
    id: 5,
    title: 'iMac 24" M3 Chip',
    price: 1299.99,
    rating: 4.7,
    reviews: 198,
    image: "img/imac.jpg",
    category: "desktop",
    brand: "apple",
    description: "iMac todo en uno con chip M3, 8GB RAM unificada, 256GB SSD"
  },
  {
    id: 6,
    title: "Laptop HP Pavilion Gaming",
    price: 899.99,
    rating: 4.2,
    reviews: 267,
    image: "img/pavilongaming.jpg",
    category: "gaming",
    brand: "hp",
    description: "Laptop gaming con GTX 1650, AMD Ryzen 5, 8GB RAM, 256GB SSD"
  },
  {
    id: 7,
    title: "PC Workstation Intel i9",
    price: 2299.99,
    rating: 4.9,
    reviews: 45,
    image: "img/workstation.jpg",
    category: "desktop",
    brand: "custom",
    description: "Workstation profesional con Intel i9, RTX A4000, 64GB RAM, 2TB NVMe"
  },
  {
    id: 8,
    title: "Laptop Lenovo ThinkPad X1",
    price: 1499.99,
    rating: 4.6,
    reviews: 178,
    image: "img/lenovothinkpad.jpg",
    category: "office",
    brand: "lenovo",
    description: "ThinkPad empresarial con Intel i7, 16GB RAM, 512GB SSD, seguridad avanzada"
  },
]

// DOM elements
const productsGrid = document.getElementById("products-grid")

// Initialize the page
document.addEventListener("DOMContentLoaded", () => {
  loadProducts()
  setupEventListeners()
  animateOnScroll()
})

// Load products into the grid
function loadProducts() {
  productsGrid.innerHTML = ""

  products.forEach((product) => {
    const productCard = createProductCard(product)
    productsGrid.appendChild(productCard)
  })
}

// Create product card element
function createProductCard(product) {
  const card = document.createElement("div")
  card.className = "product-card"
  card.style.animation = "fadeInUp 0.6s ease-out"

  card.innerHTML = `
        <div class="product-image">
            <img src="${product.image}" alt="${product.title}">
        </div>
        <div class="product-info">
            <h3 class="product-title">${product.title}</h3>
            <div class="product-rating">
                <div class="stars">${generateStars(product.rating)}</div>
                <span class="rating-count">(${product.reviews})</span>
            </div>
            <div class="product-price">$${product.price.toFixed(2)}</div>
            <button class="add-to-cart" onclick="addToCartFromIndex(${product.id})">
                <i class="fas fa-cart-plus"></i> Agregar al carrito
            </button>
        </div>
    `

  return card
}

// Generate star rating
function generateStars(rating) {
  const fullStars = Math.floor(rating)
  const hasHalfStar = rating % 1 !== 0
  let stars = ""

  for (let i = 0; i < fullStars; i++) {
    stars += '<i class="fas fa-star"></i>'
  }

  if (hasHalfStar) {
    stars += '<i class="fas fa-star-half-alt"></i>'
  }

  const emptyStars = 5 - Math.ceil(rating)
  for (let i = 0; i < emptyStars; i++) {
    stars += '<i class="far fa-star"></i>'
  }

  return stars
}

// Add product to cart using shared utilities
function addToCartFromIndex(productId) {
  const product = products.find((p) => p.id === productId)
  if (product && window.CartUtils) {
    window.CartUtils.addToCart(product)
  }
}

// Setup event listeners
function setupEventListeners() {
  // Search functionality
  const searchInput = document.querySelector(".search-bar input")
  const searchBtn = document.querySelector(".search-btn")

  searchBtn.addEventListener("click", performSearch)
  searchInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
      performSearch()
    }
  })

  // Category cards click
  const categoryCards = document.querySelectorAll(".category-card")
  categoryCards.forEach((card) => {
    card.addEventListener("click", function () {
      const category = this.dataset.category
      filterByCategory(category)
    })
  })

  // Newsletter form
  const newsletterForm = document.querySelector(".newsletter-form")
  newsletterForm.addEventListener("submit", function (e) {
    e.preventDefault()
    const email = this.querySelector("input").value
    if (email) {
      if (window.CartUtils) {
        window.CartUtils.showNotification("¡Suscripción exitosa! Gracias por unirte.")
      }
      this.querySelector("input").value = ""
    }
  })

  // Smooth scrolling for navigation
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault()
      const target = document.querySelector(this.getAttribute("href"))
      if (target) {
        target.scrollIntoView({
          behavior: "smooth",
          block: "start",
        })
      }
    })
  })
}

// Perform search
function performSearch() {
  const searchTerm = document.querySelector(".search-bar input").value.toLowerCase()
  const filteredProducts = products.filter((product) =>
    product.title.toLowerCase().includes(searchTerm) ||
    product.description.toLowerCase().includes(searchTerm)
  )
  displayFilteredProducts(filteredProducts)
}

// Filter by category
function filterByCategory(category) {
  let filteredProducts = products

  if (category && category !== "all") {
    filteredProducts = products.filter((product) => product.category === category)
  }

  displayFilteredProducts(filteredProducts)
}

// Display filtered products
function displayFilteredProducts(filteredProducts) {
  productsGrid.innerHTML = ""

  if (filteredProducts.length === 0) {
    productsGrid.innerHTML =
      '<p style="text-align: center; grid-column: 1/-1; font-size: 18px; color: #666;">No se encontraron productos</p>'
    return
  }

  filteredProducts.forEach((product, index) => {
    const productCard = createProductCard(product)
    productCard.style.animationDelay = `${index * 0.1}s`
    productsGrid.appendChild(productCard)
  })
}

// Animate elements on scroll
function animateOnScroll() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.style.animation = "fadeInUp 0.6s ease-out"
      }
    })
  })

  // Observe category cards
  document.querySelectorAll(".category-card").forEach((card) => {
    observer.observe(card)
  })
}

// Additional CSS animations
const additionalStyles = `
    @keyframes pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.2); }
        100% { transform: scale(1); }
    }
    
    @keyframes bounce {
        0%, 20%, 60%, 100% { transform: translateY(0); }
        40% { transform: translateY(-10px); }
        80% { transform: translateY(-5px); }
    }
    
    @keyframes slideInRight {
        from {
            opacity: 0;
            transform: translateX(100px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    
    @keyframes slideOutRight {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(100px);
        }
    }
`

// Add additional styles to the page
const styleSheet = document.createElement("style")
styleSheet.textContent = additionalStyles
document.head.appendChild(styleSheet)

// Parallax effect for hero banner
window.addEventListener("scroll", () => {
  const scrolled = window.pageYOffset
  const banner = document.querySelector(".hero-banner")
  if (banner) {
    banner.style.transform = `translateY(${scrolled * 0.5}px)`
  }
})

// Add floating animation to category cards
function addFloatingAnimation() {
  const categoryCards = document.querySelectorAll(".category-card")
  categoryCards.forEach((card, index) => {
    card.style.animationDelay = `${index * 0.2}s`
    card.style.animation = "float 3s ease-in-out infinite"
  })
}

// Enhanced scroll animations
function enhancedScrollAnimations() {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = "1"
          entry.target.style.transform = "translateY(0)"
        }
      })
    },
    {
      threshold: 0.1,
      rootMargin: "0px 0px -50px 0px",
    },
  )

  // Observe all animated elements
  document.querySelectorAll(".category-card, .product-card, .footer-section").forEach((el) => {
    el.style.opacity = "0"
    el.style.transform = "translateY(30px)"
    el.style.transition = "all 0.6s ease-out"
    observer.observe(el)
  })
}

// Add sparkle effect to buttons
function addSparkleEffect() {
  const buttons = document.querySelectorAll(".cta-button, .add-to-cart, .search-btn")

  buttons.forEach((button) => {
    button.addEventListener("mouseenter", function () {
      createSparkles(this)
    })
  })
}

function createSparkles(element) {
  for (let i = 0; i < 6; i++) {
    const sparkle = document.createElement("div")
    sparkle.style.cssText = `
      position: absolute;
      width: 4px;
      height: 4px;
      background: white;
      border-radius: 50%;
      pointer-events: none;
      animation: sparkle 0.6s ease-out forwards;
      top: ${Math.random() * 100}%;
      left: ${Math.random() * 100}%;
      z-index: 1000;
    `

    element.style.position = "relative"
    element.appendChild(sparkle)

    setTimeout(() => {
      if (sparkle.parentNode) {
        sparkle.parentNode.removeChild(sparkle)
      }
    }, 600)
  }
}

// Enhanced product card interactions
function enhanceProductCards() {
  const productCards = document.querySelectorAll(".product-card")

  productCards.forEach((card) => {
    card.addEventListener("mouseenter", function () {
      this.style.transform = "translateY(-8px) scale(1.02)"
      this.style.boxShadow = "0 25px 60px rgba(0, 0, 0, 0.2)"
    })

    card.addEventListener("mouseleave", function () {
      this.style.transform = "translateY(0) scale(1)"
      this.style.boxShadow = "0 8px 30px rgba(0, 0, 0, 0.08)"
    })
  })
}

// Initialize enhanced features
document.addEventListener("DOMContentLoaded", () => {
  setTimeout(() => {
    addFloatingAnimation()
    enhancedScrollAnimations()
    addSparkleEffect()
    enhanceProductCards()
  }, 500)
})

// Add sparkle animation CSS
const sparkleStyles = `
  @keyframes sparkle {
    0% {
      opacity: 0;
      transform: scale(0) rotate(0deg);
    }
    50% {
      opacity: 1;
      transform: scale(1) rotate(180deg);
    }
    100% {
      opacity: 0;
      transform: scale(0) rotate(360deg);
    }
  }
`

const sparkleStyleSheet = document.createElement("style")
sparkleStyleSheet.textContent = sparkleStyles
document.head.appendChild(sparkleStyleSheet)
