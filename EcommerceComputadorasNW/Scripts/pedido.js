// Checkout Page JavaScript

// DOM Elements
const checkoutForm = document.getElementById("checkoutForm")
const savedAddressesModal = document.getElementById("savedAddressesModal")
const shippingOptions = document.querySelectorAll('input[name="shipping"]')
const sameAsShippingCheckbox = document.getElementById("sameAsShipping")
const billingAddressFields = document.getElementById("billingAddressFields")

// Initialize
document.addEventListener("DOMContentLoaded", () => {
    setupFormValidation()
    setupShippingCalculation()
    setupAddressToggle()
    loadUserData()
    setupFormAnimations()
})

// Form Validation Setup
function setupFormValidation() {
    if (checkoutForm) {
        checkoutForm.addEventListener("submit", handleCheckoutSubmit)

        // Real-time validation
        const inputs = checkoutForm.querySelectorAll("input, select, textarea")
        inputs.forEach((input) => {
            input.addEventListener("blur", validateField)
            input.addEventListener("input", clearFieldError)
        })
    }
}

// Handle Checkout Form Submit
async function handleCheckoutSubmit(e) {
    e.preventDefault()

    const formData = new FormData(checkoutForm)
    const checkoutData = Object.fromEntries(formData)

    // Validate form
    if (!validateCheckoutForm(checkoutData)) {
        return
    }

    try {
        showLoading(true)

        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 2000))

        // Store checkout data
        localStorage.setItem("checkoutData", JSON.stringify(checkoutData))

        showNotification("Información guardada correctamente", "success")

        // Redirect to payment page
        setTimeout(() => {
            window.location.href = "payment.html"
        }, 1500)
    } catch (error) {
        showNotification("Error al procesar la información", "error")
    } finally {
        showLoading(false)
    }
}

// Validate Checkout Form
function validateCheckoutForm(data) {
    let isValid = true

    // Required fields validation
    const requiredFields = ["firstName", "lastName", "email", "phone", "address", "city", "state", "zipCode", "country"]

    requiredFields.forEach((field) => {
        if (!data[field] || data[field].trim() === "") {
            setFieldError(field, "Este campo es obligatorio")
            isValid = false
        }
    })

    // Email validation
    if (data.email && !isValidEmail(data.email)) {
        setFieldError("email", "Por favor ingresa un email válido")
        isValid = false
    }

    // Phone validation
    if (data.phone && !isValidPhone(data.phone)) {
        setFieldError("phone", "Por favor ingresa un teléfono válido")
        isValid = false
    }

    // Zip code validation
    if (data.zipCode && !isValidZipCode(data.zipCode)) {
        setFieldError("zipCode", "Por favor ingresa un código postal válido")
        isValid = false
    }

    return isValid
}

// Field Validation
function validateField(e) {
    const field = e.target
    const value = field.value.trim()
    const fieldName = field.name

    clearFieldError(field.id)

    if (!value && field.required) {
        setFieldError(field.id, "Este campo es obligatorio")
        return
    }

    switch (fieldName) {
        case "email":
            if (value && !isValidEmail(value)) {
                setFieldError(field.id, "Email no válido")
            } else if (value) {
                setFieldSuccess(field.id)
            }
            break

        case "phone":
            if (value && !isValidPhone(value)) {
                setFieldError(field.id, "Teléfono no válido")
            } else if (value) {
                setFieldSuccess(field.id)
            }
            break

        case "zipCode":
        case "billingZipCode":
            if (value && !isValidZipCode(value)) {
                setFieldError(field.id, "Código postal no válido")
            } else if (value) {
                setFieldSuccess(field.id)
            }
            break

        default:
            if (value) {
                setFieldSuccess(field.id)
            }
            break
    }
}

// Shipping Calculation Setup
function setupShippingCalculation() {
    shippingOptions.forEach((option) => {
        option.addEventListener("change", updateShippingCost)
    })
}

// Update Shipping Cost
function updateShippingCost() {
    const selectedShipping = document.querySelector('input[name="shipping"]:checked')
    const shippingCostElement = document.getElementById("shippingCost")
    const finalTotalElement = document.getElementById("finalTotal")

    if (!selectedShipping || !shippingCostElement || !finalTotalElement) return

    const subtotal = 1599.98
    const taxes = 127.99
    let shippingCost = 0
    let shippingText = "Gratis"

    switch (selectedShipping.value) {
        case "express":
            shippingCost = 199
            shippingText = "$199"
            break
        case "overnight":
            shippingCost = 399
            shippingText = "$399"
            break
    }

    const total = subtotal + taxes + shippingCost

    shippingCostElement.textContent = shippingText
    finalTotalElement.textContent = `$${total.toFixed(2)}`

    // Animate the change
    shippingCostElement.style.animation = "none"
    finalTotalElement.style.animation = "none"
    setTimeout(() => {
        shippingCostElement.style.animation = "pulse 0.5s ease-in-out"
        finalTotalElement.style.animation = "pulse 0.5s ease-in-out"
    }, 10)
}

// Address Toggle Setup
function setupAddressToggle() {
    if (sameAsShippingCheckbox) {
        sameAsShippingCheckbox.addEventListener("change", toggleBillingAddress)
    }
}

// Toggle Billing Address
function toggleBillingAddress() {
    const isChecked = sameAsShippingCheckbox.checked

    if (isChecked) {
        billingAddressFields.style.display = "none"
        // Clear billing address fields
        const billingInputs = billingAddressFields.querySelectorAll("input, select")
        billingInputs.forEach((input) => {
            input.removeAttribute("required")
            clearFieldError(input.id)
        })
    } else {
        billingAddressFields.style.display = "block"
        // Make billing address fields required
        const billingInputs = billingAddressFields.querySelectorAll("input, select")
        billingInputs.forEach((input) => {
            if (input.name.includes("billing")) {
                input.setAttribute("required", "true")
            }
        })
    }
}

// Saved Addresses Modal
function showSavedAddresses() {
    savedAddressesModal.style.display = "block"
    document.body.style.overflow = "hidden"
}

function closeSavedAddresses() {
    savedAddressesModal.style.display = "none"
    document.body.style.overflow = "auto"
}

// Promo Code
function applyPromoCode() {
    const promoCodeInput = document.getElementById("promoCode")
    const promoCode = promoCodeInput.value.trim().toUpperCase()

    const validCodes = {
        SAVE10: { discount: 0.1, description: "10% de descuento" },
        WELCOME: { discount: 50, description: "$50 de descuento" },
        FREESHIP: { discount: 0, description: "Envío gratis", freeShipping: true },
    }

    if (validCodes[promoCode]) {
        const code = validCodes[promoCode]
        showNotification(`Código aplicado: ${code.description}`, "success")
        promoCodeInput.value = ""
        // Here you would update the totals
    } else if (promoCode) {
        showNotification("Código de descuento no válido", "error")
    } else {
        showNotification("Por favor ingresa un código", "warning")
    }
}

// Load User Data
function loadUserData() {
    // Check if user is logged in and has saved data
    const userData = {
        firstName: "Juan",
        lastName: "Pérez",
        email: "juan.perez@email.com",
        phone: "+1 (555) 123-4567",
    }

    // Pre-fill form if user data exists
    Object.keys(userData).forEach((key) => {
        const field = document.getElementById(key)
        if (field) {
            field.value = userData[key]
        }
    })
}

// Navigation Functions
function goBack() {
    if (confirm("¿Estás seguro de que quieres volver? Se perderá la información ingresada.")) {
        window.history.back()
    }
}

// Form Animations
function setupFormAnimations() {
    const formSections = document.querySelectorAll(".form-section")
    formSections.forEach((section, index) => {
        section.style.opacity = "0"
        section.style.transform = "translateY(30px)"
        section.style.animation = `fadeIn 0.6s ease-out ${index * 0.1}s forwards`
    })
}

// Utility Functions
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
}

function isValidPhone(phone) {
    const phoneRegex = /^[+]?[1-9][\d]{0,15}$/
    return phoneRegex.test(phone.replace(/[\s\-$$$$]/g, ""))
}

function isValidZipCode(zipCode) {
    const zipRegex = /^\d{5}(-\d{4})?$/
    return zipRegex.test(zipCode)
}

function setFieldError(fieldId, message) {
    const field = document.getElementById(fieldId)
    if (!field) return

    const formGroup = field.closest(".form-group")
    formGroup.classList.remove("success")
    formGroup.classList.add("error")

    // Remove existing error message
    const existingError = formGroup.querySelector(".error-message")
    if (existingError) {
        existingError.remove()
    }

    // Add error message
    const errorDiv = document.createElement("div")
    errorDiv.className = "error-message"
    errorDiv.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`
    errorDiv.style.cssText = `
        color: var(--error-color);
        font-size: 12px;
        font-weight: 500;
        margin-top: 4px;
        display: flex;
        align-items: center;
        gap: 4px;
    `
    formGroup.appendChild(errorDiv)

    // Add error styles to input
    field.style.borderColor = "var(--error-color)"
    field.style.background = "rgba(239, 68, 68, 0.05)"
}

function setFieldSuccess(fieldId) {
    const field = document.getElementById(fieldId)
    if (!field) return

    const formGroup = field.closest(".form-group")
    formGroup.classList.remove("error")
    formGroup.classList.add("success")

    // Remove existing messages
    const existingMessage = formGroup.querySelector(".error-message, .success-message")
    if (existingMessage) {
        existingMessage.remove()
    }

    // Add success styles to input
    field.style.borderColor = "var(--success-color)"
    field.style.background = "rgba(16, 185, 129, 0.05)"
}

function clearFieldError(fieldId) {
    const field = typeof fieldId === "string" ? document.getElementById(fieldId) : fieldId
    if (!field) return

    const formGroup = field.closest(".form-group")
    formGroup.classList.remove("error", "success")

    const existingMessage = formGroup.querySelector(".error-message, .success-message")
    if (existingMessage) {
        existingMessage.remove()
    }

    // Reset input styles
    field.style.borderColor = ""
    field.style.background = ""
}

function showLoading(show) {
    const submitButton = checkoutForm.querySelector(".btn-primary")
    if (show) {
        submitButton.disabled = true
        submitButton.innerHTML = `
            <div class="loading-spinner"></div>
            <span>Procesando...</span>
        `
        document.body.style.cursor = "wait"
    } else {
        submitButton.disabled = false
        submitButton.innerHTML = `
            <span>Continuar al Pago</span>
            <i class="fas fa-arrow-right"></i>
        `
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

// Close modal when clicking outside
window.addEventListener("click", (e) => {
    if (e.target === savedAddressesModal) {
        closeSavedAddresses()
    }
})

// CSS Animations
const additionalStyles = `
    @keyframes pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.05); }
        100% { transform: scale(1); }
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
    
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .loading-spinner {
        width: 20px;
        height: 20px;
        border: 2px solid rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        border-top-color: white;
        animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
        to { transform: rotate(360deg); }
    }
    
    .form-group.error input,
    .form-group.error select,
    .form-group.error textarea {
        border-color: var(--error-color) !important;
        background: rgba(239, 68, 68, 0.05) !important;
    }
    
    .form-group.success input,
    .form-group.success select,
    .form-group.success textarea {
        border-color: var(--success-color) !important;
        background: rgba(16, 185, 129, 0.05) !important;
    }
`

// Add additional styles to the page
const styleSheet = document.createElement("style")
styleSheet.textContent = additionalStyles
document.head.appendChild(styleSheet)
