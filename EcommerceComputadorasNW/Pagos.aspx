<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Pagos.aspx.cs" Inherits="EcommerceComputadorasNW.Pagos" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Procesar Pago - TechStore</title>
    <link rel="stylesheet" href="Content/pago.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <a href="index.html">
                        <i class="fas fa-laptop"></i>
                        <span>TechStore</span>
                    </a>
                </div>
                
                <div class="checkout-progress">
                    <div class="progress-step completed">
                        <div class="step-number"><i class="fas fa-check"></i></div>
                        <span>Información</span>
                    </div>
                    <div class="progress-line completed"></div>
                    <div class="progress-step active">
                        <div class="step-number">2</div>
                        <span>Pago</span>
                    </div>
                    <div class="progress-line"></div>
                    <div class="progress-step">
                        <div class="step-number">3</div>
                        <span>Confirmación</span>
                    </div>
                </div>

                <div class="security-indicator">
                    <i class="fas fa-lock"></i>
                    <span>Conexión Segura</span>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <div class="payment-layout">
                <!-- Payment Form -->
                <div class="payment-form-section">
                    <div class="section-header">
                        <h1>Información de Pago</h1>
                        <p>Completa tu compra de forma segura</p>
                    </div>

                    <!-- Payment Methods -->
                    <div class="payment-methods">
                        <h3>Método de Pago</h3>
                        <div class="payment-options">
                            <label class="payment-option active">
                                <input type="radio" name="paymentMethod" value="card" checked>
                                <div class="option-content">
                                    <i class="fas fa-credit-card"></i>
                                    <span>Tarjeta de Crédito/Débito</span>
                                </div>
                            </label>

                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="paypal">
                                <div class="option-content">
                                    <i class="fab fa-paypal"></i>
                                    <span>PayPal</span>
                                </div>
                            </label>

                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="apple">
                                <div class="option-content">
                                    <i class="fab fa-apple-pay"></i>
                                    <span>Apple Pay</span>
                                </div>
                            </label>

                            <label class="payment-option">
                                <input type="radio" name="paymentMethod" value="google">
                                <div class="option-content">
                                    <i class="fab fa-google-pay"></i>
                                    <span>Google Pay</span>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Card Payment Form -->
                    <form id="paymentForm" class="payment-form">
                        <div id="cardPaymentSection" class="payment-section">
                            <!-- Saved Cards -->
                            <div class="saved-cards">
                                <h4>Tarjetas Guardadas</h4>
                                <div class="cards-list">
                                    <label class="saved-card">
                                        <input type="radio" name="savedCard" value="visa1234">
                                        <div class="card-visual visa">
                                            <div class="card-brand">
                                                <i class="fab fa-cc-visa"></i>
                                            </div>
                                            <div class="card-number">**** **** **** 1234</div>
                                            <div class="card-info">
                                                <span>Juan Pérez</span>
                                                <span>12/26</span>
                                            </div>
                                        </div>
                                    </label>

                                    <label class="saved-card">
                                        <input type="radio" name="savedCard" value="master5678">
                                        <div class="card-visual mastercard">
                                            <div class="card-brand">
                                                <i class="fab fa-cc-mastercard"></i>
                                            </div>
                                            <div class="card-number">**** **** **** 5678</div>
                                            <div class="card-info">
                                                <span>Juan Pérez</span>
                                                <span>08/25</span>
                                            </div>
                                        </div>
                                    </label>

                                    <label class="saved-card new-card">
                                        <input type="radio" name="savedCard" value="new" checked>
                                        <div class="new-card-content">
                                            <i class="fas fa-plus"></i>
                                            <span>Usar nueva tarjeta</span>
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <!-- New Card Form -->
                            <div id="newCardForm" class="new-card-form">
                                <div class="form-group">
                                    <label for="cardNumber">Número de Tarjeta *</label>
                                    <div class="card-input">
                                        <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" maxlength="19" required>
                                        <div class="card-brand-icon" id="cardBrandIcon"></div>
                                    </div>
                                    <div class="input-focus-effect"></div>
                                </div>

                                <div class="form-group">
                                    <label for="cardName">Nombre en la Tarjeta *</label>
                                    <input type="text" id="cardName" name="cardName" placeholder="Juan Pérez" required>
                                    <div class="input-focus-effect"></div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="expiryDate">Fecha de Vencimiento *</label>
                                        <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/AA" maxlength="5" required>
                                        <div class="input-focus-effect"></div>
                                    </div>
                                    <div class="form-group">
                                        <label for="cvv">CVV *</label>
                                        <div class="cvv-input">
                                            <input type="text" id="cvv" name="cvv" placeholder="123" maxlength="4" required>
                                            <div class="cvv-help" title="Código de 3 dígitos en el reverso de tu tarjeta">
                                                <i class="fas fa-question-circle"></i>
                                            </div>
                                        </div>
                                        <div class="input-focus-effect"></div>
                                    </div>
                                </div>

                                <div class="form-options">
                                    <label class="checkbox-container">
                                        <input type="checkbox" id="saveCard">
                                        <span class="checkmark"></span>
                                        Guardar esta tarjeta para futuras compras
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Alternative Payment Sections -->
                        <div id="paypalSection" class="payment-section" style="display: none;">
                            <div class="paypal-info">
                                <div class="paypal-logo">
                                    <i class="fab fa-paypal"></i>
                                    <span>PayPal</span>
                                </div>
                                <p>Serás redirigido a PayPal para completar tu pago de forma segura.</p>
                                <div class="paypal-benefits">
                                    <div class="benefit">
                                        <i class="fas fa-shield-alt"></i>
                                        <span>Protección del comprador</span>
                                    </div>
                                    <div class="benefit">
                                        <i class="fas fa-lock"></i>
                                        <span>Pago seguro</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="applePaySection" class="payment-section" style="display: none;">
                            <div class="apple-pay-info">
                                <div class="apple-pay-logo">
                                    <i class="fab fa-apple-pay"></i>
                                    <span>Apple Pay</span>
                                </div>
                                <p>Paga de forma rápida y segura con Touch ID o Face ID.</p>
                                <button type="button" class="apple-pay-button">
                                    <i class="fab fa-apple-pay"></i>
                                    Pagar con Apple Pay
                                </button>
                            </div>
                        </div>

                        <div id="googlePaySection" class="payment-section" style="display: none;">
                            <div class="google-pay-info">
                                <div class="google-pay-logo">
                                    <i class="fab fa-google-pay"></i>
                                    <span>Google Pay</span>
                                </div>
                                <p>Pago rápido y seguro con tu cuenta de Google.</p>
                                <button type="button" class="google-pay-button">
                                    <i class="fab fa-google-pay"></i>
                                    Pagar con Google Pay
                                </button>
                            </div>
                        </div>

                        <!-- Billing Information -->
                        <div class="billing-section">
                            <h4>Información de Facturación</h4>
                            <div class="billing-summary">
                                <div class="billing-address">
                                    <h5>Dirección de Facturación</h5>
                                    <p>Av. Principal 123, Apt 4B<br>Ciudad de México, CDMX 01234<br>México</p>
                                    <button type="button" class="change-address">Cambiar</button>
                                </div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="button" class="btn-secondary" onclick="goBack()">
                                <i class="fas fa-arrow-left"></i>
                                Volver
                            </button>
                            <button type="submit" class="btn-primary" id="payButton">
                                <div class="button-content">
                                    <i class="fas fa-lock"></i>
                                    <span>Procesar Pago</span>
                                    <div class="button-loader"></div>
                                </div>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Order Summary -->
                <div class="order-summary-section">
                    <div class="order-summary">
                        <h3>Resumen del Pedido</h3>
                        
                        <div class="order-items">
                            <div class="order-item">
                                <img src="/placeholder.svg?height=60&width=60" alt="Producto">
                                <div class="item-details">
                                    <h4>Laptop Gaming ASUS ROG</h4>
                                    <p>Cantidad: 1</p>
                                    <span class="item-price">$1,299.99</span>
                                </div>
                            </div>

                            <div class="order-item">
                                <img src="/placeholder.svg?height=60&width=60" alt="Producto">
                                <div class="item-details">
                                    <h4>Monitor Gaming 27"</h4>
                                    <p>Cantidad: 1</p>
                                    <span class="item-price">$299.99</span>
                                </div>
                            </div>
                        </div>

                        <div class="order-totals">
                            <div class="total-line">
                                <span>Subtotal:</span>
                                <span>$1,599.98</span>
                            </div>
                            <div class="total-line">
                                <span>Envío Express:</span>
                                <span>$199.00</span>
                            </div>
                            <div class="total-line">
                                <span>Impuestos:</span>
                                <span>$143.99</span>
                            </div>
                            <div class="total-line discount">
                                <span>Descuento (SAVE10):</span>
                                <span>-$159.99</span>
                            </div>
                            <div class="total-line total">
                                <span>Total a Pagar:</span>
                                <span>$1,782.98</span>
                            </div>
                        </div>

                        <div class="payment-security">
                            <div class="security-badges">
                                <div class="security-badge">
                                    <i class="fas fa-shield-alt"></i>
                                    <span>SSL Seguro</span>
                                </div>
                                <div class="security-badge">
                                    <i class="fas fa-lock"></i>
                                    <span>Encriptado 256-bit</span>
                                </div>
                            </div>
                            
                            <div class="accepted-cards">
                                <h5>Tarjetas Aceptadas</h5>
                                <div class="card-icons">
                                    <i class="fab fa-cc-visa"></i>
                                    <i class="fab fa-cc-mastercard"></i>
                                    <i class="fab fa-cc-amex"></i>
                                    <i class="fab fa-cc-discover"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Processing Modal -->
    <div id="processingModal" class="modal">
        <div class="modal-content processing">
            <div class="processing-animation">
                <div class="spinner"></div>
                <h3>Procesando tu pago...</h3>
                <p>Por favor no cierres esta ventana</p>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content success">
            <div class="success-animation">
                <div class="success-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h3>¡Pago Exitoso!</h3>
                <p>Tu pedido ha sido procesado correctamente</p>
                <div class="order-number">
                    <span>Número de pedido: <strong>#TS-2024-003</strong></span>
                </div>
                <div class="success-actions">
                    <button class="btn-primary" onclick="goToOrderConfirmation()">
                        Ver Detalles del Pedido
                    </button>
                    <button class="btn-secondary" onclick="continueShopping()">
                        Continuar Comprando
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="Scripts/pago.js"></script>
</body>
</html>
