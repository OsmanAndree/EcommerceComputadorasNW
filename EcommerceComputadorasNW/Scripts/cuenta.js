// Account Page JavaScript

// DOM Elements
const navItems = document.querySelectorAll(".nav-item[data-section]")
const contentSections = document.querySelectorAll(".content-section")

// Initialize
document.addEventListener("DOMContentLoaded", () => {
  setupNavigation()
  setupFormHandlers()
  setupPasswordToggles()
  setupNotificationToggles()
  loadUserData()
})

// Navigation Setup
function setupNavigation() {
  navItems.forEach((item) => {
    item.addEventListener("click", (e) => {
      e.preventDefault()
      const sectionId = item.dataset.section
      showSection(sectionId)

      // Update active nav item
      navItems.forEach((nav) => nav.classList.remove("active"))
      item.classList.add("active")
    })
  })
}

// Show Section
function showSection(sectionId) {
  contentSections.forEach((section) => {
    section.classList.remove("active")
  })

  const targetSection = document.getElementById(sectionId)
  if (targetSection) {
    targetSection.classList.add("active")
  }
}

// Form Handlers Setup
function setupFormHandlers() {
  // Personal Info Form
  const personalInfoForm = document.getElementById("personal-info")
  if (personalInfoForm) {
    personalInfoForm.addEventListener("submit", handlePersonalInfoUpdate)
  }

  // Security Form
  const securityForms = document.querySelectorAll(".security-form")
  securityForms.forEach((form) => {
    form.addEventListener("submit", handleSecurityUpdate)
  })

  // Order filters
  const filterBtns = document.querySelectorAll(".filter-btn")
  filterBtns.forEach((btn) => {
    btn.addEventListener("click", (e) => {
      filterBtns.forEach((b) => b.classList.remove("active"))
      btn.classList.add("active")
      filterOrders(btn.dataset.filter)
    })
  })
}

// Toggle Edit Mode
function toggleEdit(formId) {
  const form = document.getElementById(formId)
  const inputs = form.querySelectorAll("input, select")
  const actions = form.querySelector(".form-actions")
  const editBtn = form.parentElement.querySelector(".edit-btn")

  const isReadonly = inputs[0].hasAttribute("readonly")

  inputs.forEach((input) => {
    if (isReadonly) {
      input.removeAttribute("readonly")
      input.removeAttribute("disabled")
      input.style.background = "white"
    } else {
      input.setAttribute("readonly", true)
      input.setAttribute("disabled", true)
      input.style.background = "var(--bg-secondary)"
    }
  })

  if (actions) {
    actions.style.display = isReadonly ? "flex" : "none"
  }

  editBtn.innerHTML = isReadonly ? '<i class="fas fa-times"></i> Cancelar' : '<i class="fas fa-edit"></i> Editar'
}

// Cancel Edit
function cancelEdit(formId) {
  toggleEdit(formId)
  // Reset form values here if needed
  showNotification("Cambios cancelados", "info")
}

// Handle Personal Info Update
async function handlePersonalInfoUpdate(e) {
  e.preventDefault()

  const formData = new FormData(e.target)
  const userData = Object.fromEntries(formData)

  try {
    showLoading(true)

    // Simulate API call
    await new Promise((resolve) => setTimeout(resolve, 1500))

    showNotification("Información actualizada correctamente", "success")
    toggleEdit("personal-info")
  } catch (error) {
    showNotification("Error al actualizar la información", "error")
  } finally {
    showLoading(false)
  }
}

// Handle Security Update
async function handleSecurityUpdate(e) {
  e.preventDefault()

  const formData = new FormData(e.target)
  const currentPassword = formData.get("currentPassword")
  const newPassword = formData.get("newPassword")
  const confirmPassword = formData.get("confirmPassword")

  // Validation
  if (newPassword !== confirmPassword) {
    showNotification("Las contraseñas no coinciden", "error")
    return
  }

  if (newPassword.length < 8) {
    showNotification("La contraseña debe tener al menos 8 caracteres", "error")
    return
  }

  try {
    showLoading(true)

    // Simulate API call
    await new Promise((resolve) => setTimeout(resolve, 2000))

    showNotification("Contraseña actualizada correctamente", "success")
    e.target.reset()
  } catch (error) {
    showNotification("Error al actualizar la contraseña", "error")
  } finally {
    showLoading(false)
  }
}

// Password Toggle Setup
function setupPasswordToggles() {
  const toggles = document.querySelectorAll(".password-toggle")

  toggles.forEach((toggle) => {
    toggle.addEventListener("click", () => {
      const input = toggle.parentElement.querySelector("input")
      const icon = toggle.querySelector("i")

      if (input.type === "password") {
        input.type = "text"
        icon.className = "fas fa-eye-slash"
      } else {
        input.type = "password"
        icon.className = "fas fa-eye"
      }
    })
  })
}

// Notification Toggles Setup
function setupNotificationToggles() {
  const toggles = document.querySelectorAll(".toggle-switch input")

  toggles.forEach((toggle) => {
    toggle.addEventListener("change", (e) => {
      const isEnabled = e.target.checked
      const notificationItem = e.target.closest(".notification-item")
      const notificationInfo = notificationItem.querySelector(".notification-info h4").textContent

      // Simulate API call to update notification preference
      updateNotificationPreference(notificationInfo, isEnabled)
    })
  })
}

// Update Notification Preference
async function updateNotificationPreference(type, enabled) {
  try {
    // Simulate API call
    await new Promise((resolve) => setTimeout(resolve, 500))

    const status = enabled ? "activadas" : "desactivadas"
    showNotification(`Notificaciones de ${type} ${status}`, "success")
  } catch (error) {
    showNotification("Error al actualizar las preferencias", "error")
  }
}

// Filter Orders
function filterOrders(filter) {
  const orderCards = document.querySelectorAll(".order-card")

  orderCards.forEach((card) => {
    const status = card.querySelector(".order-status").classList
    let shouldShow = false

    switch (filter) {
      case "all":
        shouldShow = true
        break
      case "pending":
        shouldShow = status.contains("pending")
        break
      case "shipped":
        shouldShow = status.contains("shipped")
        break
      case "delivered":
        shouldShow = status.contains("delivered")
        break
    }

    card.style.display = shouldShow ? "block" : "none"
  })
}

// Load User Data
function loadUserData() {
  // Simulate loading user data
  const userData = {
    name: "Juan Pérez",
    email: "juan.perez@email.com",
    phone: "+1 (555) 123-4567",
    totalOrders: 24,
    totalSpent: 3450,
    favorites: 12,
    rating: 4.8,
  }

  // Update stats
  updateStats(userData)
}

// Update Stats
function updateStats(data) {
  const statNumbers = document.querySelectorAll(".stat-number")

  if (statNumbers.length >= 4) {
    statNumbers[0].textContent = data.totalOrders
    statNumbers[1].textContent = `$${data.totalSpent.toLocaleString()}`
    statNumbers[2].textContent = data.favorites
    statNumbers[3].textContent = data.rating
  }
}

// Modal Functions
function openAddressModal() {
  showNotification("Modal de dirección se abriría aquí", "info")
}

function openPaymentModal() {
  showNotification("Modal de método de pago se abriría aquí", "info")
}

// Logout Function
function logout() {
    if (confirm("¿Estás seguro de que quieres cerrar sesión?")) {


        showNotification("Cerrando sesión...", "info");

        setTimeout(() => {
            window.location.href = "Login.aspx";
        }, 1500);
    }

// Utility Functions
function showLoading(show) {
  const loadingElements = document.querySelectorAll(".loading-overlay")

  if (show) {
    document.body.style.cursor = "wait"
  } else {
    document.body.style.cursor = "default"
  }
}

function showNotification(message, type = "success") {
  // Remove existing notifications
  const existingNotifications = document.querySelectorAll(".notification")
  existingNotifications.forEach((notification) => notification.remove())

  const notification = document.createElement("div")
  notification.className = `notification ${type}`

  const icons = {
    success: "fas fa-check-circle",
    error: "fas fa-exclamation-circle",
    info: "fas fa-info-circle",
    warning: "fas fa-exclamation-triangle",
  }

  const colors = {
    success: "linear-gradient(135deg, #10b981, #059669)",
    error: "linear-gradient(135deg, #ef4444, #dc2626)",
    info: "linear-gradient(135deg, #6366f1, #4f46e5)",
    warning: "linear-gradient(135deg, #f59e0b, #d97706)",
  }

  notification.innerHTML = `<i class="${icons[type]}"></i> ${message}`
  notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${colors[type]};
        color: white;
        padding: 16px 24px;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        z-index: 10000;
        animation: slideInRight 0.3s ease-out;
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 8px;
        max-width: 400px;
    `

  document.body.appendChild(notification)

  // Auto remove after 4 seconds
  setTimeout(() => {
    if (notification.parentNode) {
      notification.style.animation = "slideOutRight 0.3s ease-in"
      setTimeout(() => {
        notification.remove()
      }, 300)
    }
  }, 4000)
}

// Avatar Upload Handler
document.addEventListener("DOMContentLoaded", () => {
  const avatarEditBtn = document.querySelector(".avatar-edit-btn")
  if (avatarEditBtn) {
    avatarEditBtn.addEventListener("click", () => {
      const input = document.createElement("input")
      input.type = "file"
      input.accept = "image/*"
      input.onchange = handleAvatarUpload
      input.click()
    })
  }
})

function handleAvatarUpload(e) {
  const file = e.target.files[0]
  if (file) {
    const reader = new FileReader()
    reader.onload = (e) => {
      const avatarImages = document.querySelectorAll(".user-avatar img, .user-avatar-large img")
      avatarImages.forEach((img) => {
        img.src = e.target.result
      })
      showNotification("Foto de perfil actualizada", "success")
    }
    reader.readAsDataURL(file)
  }
}

// Wishlist Functions
function removeFromWishlist(productId) {
  const wishlistItem = document.querySelector(`[data-product-id="${productId}"]`)
  if (wishlistItem) {
    wishlistItem.style.animation = "fadeOut 0.3s ease-out"
    setTimeout(() => {
      wishlistItem.remove()
      showNotification("Producto eliminado de la lista de deseos", "success")
    }, 300)
  }
}

function addToCartFromWishlist(productId) {
  showNotification("Producto agregado al carrito", "success")
  // Here you would typically call your cart API
}

// Order Tracking
function trackOrder(orderId) {
  showNotification(`Rastreando pedido ${orderId}...`, "info")
  // Here you would typically redirect to tracking page
}

// Download Invoice
function downloadInvoice(orderId) {
  showNotification(`Descargando factura para pedido ${orderId}...`, "info")
  // Here you would typically trigger file download
}

// CSS Animations
const additionalStyles = `
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
    
    @keyframes fadeOut {
        from {
            opacity: 1;
            transform: scale(1);
        }
        to {
            opacity: 0;
            transform: scale(0.8);
        }
    }
`

// Add additional styles to the page
const styleSheet = document.createElement("style")
styleSheet.textContent = additionalStyles
document.head.appendChild(styleSheet)

// Initialize tooltips and other interactive elements
function initializeInteractiveElements() {
  // Add hover effects to cards
  const cards = document.querySelectorAll(".profile-card, .order-card, .address-card, .payment-card, .wishlist-item")

  cards.forEach((card) => {
    card.addEventListener("mouseenter", function () {
      this.style.transform = "translateY(-2px)"
      this.style.boxShadow = "var(--shadow-xl)"
    })

    card.addEventListener("mouseleave", function () {
      this.style.transform = "translateY(0)"
      this.style.boxShadow = "var(--shadow-md)"
    })
  })
}

// Call initialization functions
document.addEventListener("DOMContentLoaded", () => {
  setTimeout(initializeInteractiveElements, 500)
})
}
