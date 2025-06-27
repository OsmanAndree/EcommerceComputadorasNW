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

// Función para actualizar el contador del carrito en el header
function updateCartBadge(count, badgeId) {
    const badge = document.getElementById(badgeId);
    if (badge) {
        badge.innerText = count;
        if (count > 0) {
            badge.style.transform = 'scale(1.2)';
            badge.style.transition = 'transform 0.2s ease-out';
            setTimeout(() => {
                badge.style.transform = 'scale(1)';
            }, 200);
        }
    }
}

// Función para mostrar mensajes emergentes (toast)
function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast-notification ${type}`;
    toast.innerText = message;

    document.body.appendChild(toast);

    setTimeout(() => {
        toast.classList.add('show');
    }, 10);

    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => {
            document.body.removeChild(toast);
        }, 500);
    }, 3000);
}

document.addEventListener('DOMContentLoaded', function () {
    // Escuchar cambios en las opciones de envío
    const shippingOptions = document.querySelectorAll('input[name="shipping"]');
    shippingOptions.forEach(radio => {
        radio.addEventListener('change', updateSummary);
    });

    // Llamada inicial para asegurar que los valores son correctos al cargar la página
    updateSummary();
});

function updateSummary() {
    // Obtener el subtotal (necesitamos una forma de leerlo desde el servidor)
    const subtotalSpan = document.getElementById('<%= subtotal.ClientID %>');
    let subtotalValue = 0;
    if (subtotalSpan) {
        // Convertir el texto de moneda (ej: "$1,234.56") a un número
        subtotalValue = parseFloat(subtotalSpan.innerText.replace(/[^0-9.-]+/g, ""));
    }

    // Obtener el costo de envío seleccionado
    const selectedShipping = document.querySelector('input[name="shipping"]:checked');
    let shippingValue = 0;
    if (selectedShipping) {
        // El precio está en el label asociado
        const priceSpan = selectedShipping.nextElementSibling.querySelector('.shipping-price');
        shippingValue = parseFloat(priceSpan.innerText.replace(/[^0-9.-]+/g, ""));
    }

    // Obtener descuento
    const discountSpan = document.getElementById('<%= discount.ClientID %>');
    let discountValue = parseFloat(discountSpan.innerText.replace(/[^0-9.-]+/g, ""));

    // Calcular el total
    const totalValue = subtotalValue + shippingValue - Math.abs(discountValue); // usamos Math.abs por si el descuento es negativo

    // Actualizar los spans en la página
    const shippingDisplay = document.getElementById('<%= shipping.ClientID %>');
    const totalDisplay = document.getElementById('<%= total.ClientID %>');

    if (shippingDisplay) shippingDisplay.innerText = shippingValue.toLocaleString('es-HN', { style: 'currency', currency: 'USD' });
    if (totalDisplay) totalDisplay.innerText = totalValue.toLocaleString('es-HN', { style: 'currency', currency: 'USD' });
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
