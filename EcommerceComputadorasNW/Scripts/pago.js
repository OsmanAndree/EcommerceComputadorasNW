// Payment Page JavaScript

// DOM Elements
const paymentForm = document.getElementById("paymentForm")
const paymentMethodInputs = document.querySelectorAll('input[name="paymentMethod"]')
const savedCardInputs = document.querySelectorAll('input[name="savedCard"]')
const cardNumberInput = document.getElementById("cardNumber")
const expiryDateInput = document.getElementById("expiryDate")
const cvvInput = document.getElementById("cvv")
const cardBrandIcon = document.getElementById("cardBrandIcon")
const newCardForm = document.getElementById("newCardForm")
const payButton = document.getElementById("payButton")
const processingModal = document.getElementById("processingModal")
const successModal = document.getElementById("successModal")

// Initialize
document.addEventListener("DOMContentLoaded", () => {
    setupPaymentMethods()
    setupCardValidation()
    setupFormValidation()
    loadCheckoutData()
    setupCardSelection()
})

// Payment Methods Setup
function setupPaymentMethods() {
    paymentMethodInputs.forEach((input) => {
        input.addEventListener("change", switchPaymentMethod)
    })
}

// Switch Payment Method
function switchPaymentMethod() {
    const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked').value
    const paymentSections = document.querySelectorAll(".payment-section")

    // Hide all sections
    paymentSections.forEach((section) => {
        section.style.display = "none"
    })

    // Show selected section
    const targetSection = document.getElementById(`${selectedMethod}PaymentSection`)
    if (targetSection) {
        targetSection.style.display = "block"
    } else if (selectedMethod === "card") {
        document.getElementById("cardPaymentSection").style.display = "block"
    }

    // Update payment options visual state
    document.querySelectorAll(".payment-option").forEach((option) => {
        option.classList.remove("active")
    })
    document.querySelector(`input[value="${selectedMethod}"]`).closest(".payment-option").classList.add("active")
}

// Card Selection Setup
function setupCardSelection() {
    savedCardInputs.forEach((input) => {
        input.addEventListener("change", toggleNewCardForm)
    })
}

// Toggle New Card Form
function toggleNewCardForm() {
    const selectedCard = document.querySelector('input[name="savedCard"]:checked').value
    const isNewCard = selectedCard === "new"

    if (isNewCard) {
        newCardForm.style.display = "block"
        newCardForm.style.animation = "fadeIn 0.5s ease-out"
        // Make new card fields required
        const newCardInputs = newCardForm.querySelectorAll("input")
        newCardInputs.forEach((input) => {
            input.setAttribute("required", "true")
        })
    } else {
        newCardForm.style.display = "none"
        // Remove required from new card fields
        const newCardInputs = newCardForm.querySelectorAll("input")
        newCardInputs.forEach((input) => {
            input.removeAttribute("required")
            clearFieldError(input.id)
        })
    }
}

// Card Validation Setup
function setupCardValidation() {
    if (cardNumberInput) {
        cardNumberInput.addEventListener("input", handleCardNumberInput)
        cardNumberInput.addEventListener("blur", validateCardNumber)
    }

    if (expiryDateInput) {
        expiryDateInput.addEventListener("input", handleExpiryInput)
        expiryDateInput.addEventListener("blur", validateExpiryDate)
    }

    if (cvvInput) {
        cvvInput.addEventListener("input", handleCvvInput)
        cvvInput.addEventListener("blur", validateCvv)
    }
}

// Handle Card Number Input
function handleCardNumberInput(e) {
    const value = e.target.value.replace(/\s/g, "").replace(/[^0-9]/gi, "")
    let formattedValue = value.match(/.{1,4}/g)?.join(" ") || value

    if (formattedValue.length > 19) {
        formattedValue = formattedValue.substring(0, 19)
    }

    e.target.value = formattedValue

    // Update card brand icon
    updateCardBrand(value)
}

// Update Card Brand
function updateCardBrand(cardNumber) {
    const cardBrands = {
        visa: /^4/,
        mastercard: /^5[1-5]/,
        amex: /^3[47]/,
        discover: /^6(?:011|5)/,
    }

    let brand = ""
    for (const [key, regex] of Object.entries(cardBrands)) {
        if (regex.test(cardNumber)) {
            brand = key
            break
        }
    }

    if (cardBrandIcon) {
        if (brand) {
            cardBrandIcon.innerHTML = `<i class="fab fa-cc-${brand}"></i>`
            cardBrandIcon.style.color = getBrandColor(brand)
        } else {
            cardBrandIcon.innerHTML = ""
        }
    }
}

// Get Brand Color
function getBrandColor(brand) {
    const colors = {
        visa: "#1a1f71",
        mastercard: "#eb001b",
        amex: "#006fcf",
        discover: "#ff6000",
    }
    return colors[brand] || "#6b7280"
}

// Handle Expiry Input
function handleExpiryInput(e) {
    let value = e.target.value.replace(/\D/g, "")
    if (value.length >= 2) {
        value = value.substring(0, 2) + "/" + value.substring(2, 4)
    }
    e.target.value = value
}

// Handle CVV Input
function handleCvvInput(e) {
    let value = e.target.value.replace(/\D/g, "")
    if (value.length > 4) {
        value = value.substring(0, 4)
    }
    e.target.value = value
}

// Validate Card Number
function validateCardNumber() {
    const cardNumber = cardNumberInput.value.replace(/\s/g, "")

    if (!cardNumber) {
        setFieldError("cardNumber", "Número de tarjeta requerido")
        return false
    }

    if (cardNumber.length < 13 || cardNumber.length > 19) {
        setFieldError("cardNumber", "Número de tarjeta inválido")
        return false
    }

    if (!luhnCheck(cardNumber)) {
        setFieldError("cardNumber", "Número de tarjeta inválido")
        return false
    }

    setFieldSuccess("cardNumber")
    return true
}

// Luhn Algorithm for Card Validation
function luhnCheck(cardNumber) {
    let sum = 0
    let alternate = false

    for (let i = cardNumber.length - 1; i >= 0; i--) {
        let n = Number.parseInt(cardNumber.charAt(i), 10)

        if (alternate) {
            n *= 2
            if (n > 9) {
                n = (n % 10) + 1
            }
        }

        sum += n
        alternate = !alternate
    }

    return sum % 10 === 0
}

// Validate Expiry Date
function validateExpiryDate() {
    const expiry = expiryDateInput.value

    if (!expiry) {
        setFieldError("expiryDate", "Fecha de vencimiento requerida")
        return false
    }

    const [month, year] = expiry.split("/")
    if (!month || !year || month.length !== 2 || year.length !== 2) {
        setFieldError("expiryDate", "Formato inválido (MM/AA)")
        return false
    }

    const monthNum = Number.parseInt(month, 10)
    const yearNum = Number.parseInt("20" + year, 10)
    const currentDate = new Date()
    const currentYear = currentDate.getFullYear()
    const currentMonth = currentDate.getMonth() + 1

    if (monthNum < 1 || monthNum > 12) {
        setFieldError("expiryDate", "Mes inválido")
        return false
    }

    if (yearNum < currentYear || (yearNum === currentYear && monthNum < currentMonth)) {
        setFieldError("expiryDate", "Tarjeta vencida")
        return false
    }

    setFieldSuccess("expiryDate")
    return true
}

// Validate CVV
function validateCvv() {
    const cvv = cvvInput.value

    if (!cvv) {
        setFieldError("cvv", "CVV requerido")
        return false
    }

    if (cvv.length < 3 || cvv.length > 4) {
        setFieldError("cvv", "CVV inválido")
        return false
    }

    setFieldSuccess("cvv")
    return true
}

// Form Validation Setup
function setupFormValidation() {
    if (paymentForm) {
        paymentForm.addEventListener("submit", handlePaymentSubmit)
    }
}

// Handle Payment Submit
async function handlePaymentSubmit(e) {
    e.preventDefault()

    const selectedPaymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value

    // Validate based on payment method
    let isValid = true

    if (selectedPaymentMethod === "card") {
        const selectedCard = document.querySelector('input[name="savedCard"]:checked').value

        if (selectedCard === "new") {
            // Validate new card form
            isValid = validateCardNumber() && validateExpiryDate() && validateCvv()

            const cardName = document.getElementById("cardName").value.trim()
            if (!cardName) {
                setFieldError("cardName", "Nombre en la tarjeta requerido")
                isValid = false
            }
        }
    }

    if (!isValid) {
        showNotification("Por favor corrige los errores en el formulario", "error")
        return
    }

    // Process payment
    await processPayment(selectedPaymentMethod)
}

// Process Payment
async function processPayment(paymentMethod) {
    try {
        // Show processing modal
        showProcessingModal()

        // Simulate payment processing
        await new Promise((resolve) => setTimeout(resolve, 3000))

        // Hide processing modal
        hideProcessingModal()

        // Show success modal
        showSuccessModal()

        // Clear form data
        clearStoredData()
    } catch (error) {
        hideProcessingModal()
        showNotification("Error al procesar el pago. Intenta nuevamente.", "error")
    }
}

// Show Processing Modal
function showProcessingModal() {
    processingModal.style.display = "block"
    document.body.style.overflow = "hidden"
    payButton.disabled = true
}

// Hide Processing Modal
function hideProcessingModal() {
    processingModal.style.display = "none"
    document.body.style.overflow = "auto"
    payButton.disabled = false
}

// Show Success Modal
function showSuccessModal() {
    successModal.style.display = "block"
    document.body.style.overflow = "hidden"
}

// Navigation Functions
function goToOrderConfirmation() {
    window.location.href = "order-confirmation.html"
}

function continueShopping() {
    window.location.href = "index.html"
}

function goBack() {
    if (confirm("¿Estás seguro de que quieres volver? Se perderá la información de pago.")) {
        window.location.href = "checkout.html"
    }
}

// Load Checkout Data
function loadCheckoutData() {
    const checkoutData = localStorage.getItem("checkoutData")
    if (checkoutData) {
        const data = JSON.parse(checkoutData)
        // Update billing address display
        updateBillingAddressDisplay(data)
    }
}

// Update Billing Address Display
function updateBillingAddressDisplay(data) {
    const billingAddressElement = document.querySelector(".billing-address p")
    if (billingAddressElement && data.address) {
        billingAddressElement.innerHTML = `
            ${data.address}<br>
            ${data.city}, ${data.state} ${data.zipCode}<br>
            ${data.country === "MX" ? "México" : data.country}
        `
    }
}

// Clear Stored Data
function clearStoredData() {
    localStorage.removeItem("checkoutData")
}

// Utility Functions
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

// Close modals when clicking outside
window.addEventListener("click", (e) => {
    if (e.target === processingModal) {
        // Don't allow closing processing modal
        return
    }
    if (e.target === successModal) {
        successModal.style.display = "none"
        document.body.style.overflow = "auto"
    }
})

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
    
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .form-group.error input {
        border-color: var(--error-color) !important;
        background: rgba(239, 68, 68, 0.05) !important;
    }
    
    .form-group.success input {
        border-color: var(--success-color) !important;
        background: rgba(16, 185, 129, 0.05) !important;
    }
`

// Add additional styles to the page
const styleSheet = document.createElement("style")
styleSheet.textContent = additionalStyles
document.head.appendChild(styleSheet)
