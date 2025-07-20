<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Pedido.aspx.cs" Inherits="EcommerceComputadorasNW.Pedido" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finalizar Pedido - TechStore</title>
    <link rel="stylesheet" href="Content/pedidos.css">
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
                    <div class="progress-step active">
                        <div class="step-number">1</div>
                        <span>Información</span>
                    </div>
                    <div class="progress-line"></div>
                    <div class="progress-step">
                        <div class="step-number">2</div>
                        <span>Pago</span>
                    </div>
                    <div class="progress-line"></div>
                    <div class="progress-step">
                        <div class="step-number">3</div>
                        <span>Confirmación</span>
                    </div>
                </div>

                <div class="header-actions">
                    <a href="account.html" class="user-link">
                        <i class="fas fa-user"></i>
                        <span>Mi Cuenta</span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <div class="checkout-layout">
                <!-- Checkout Form -->
                <div class="checkout-form-section">
                    <div class="section-header">
                        <h1>Información del Pedido</h1>
                        <p>Completa los datos para procesar tu compra</p>
                    </div>

                    <form id="checkoutForm" class="checkout-form">
                        <!-- Contact Information -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="fas fa-user"></i>
                                <h3>Información de Contacto</h3>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="firstName">Nombre *</label>
                                    <input type="text" id="firstName" name="firstName" required>
                                    <div class="input-focus-effect"></div>
                                </div>
                                <div class="form-group">
                                    <label for="lastName">Apellido *</label>
                                    <input type="text" id="lastName" name="lastName" required>
                                    <div class="input-focus-effect"></div>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="email">Email *</label>
                                    <input type="email" id="email" name="email" required>
                                    <div class="input-focus-effect"></div>
                                </div>
                                <div class="form-group">
                                    <label for="phone">Teléfono *</label>
                                    <input type="tel" id="phone" name="phone" required>
                                    <div class="input-focus-effect"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Shipping Address -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="fas fa-truck"></i>
                                <h3>Dirección de Envío</h3>
                                <!--<button type="button" class="use-saved-address" onclick="showSavedAddresses()">
                                    <i class="fas fa-bookmark"></i>
                                    Usar dirección guardada
                                </button>-->
                            </div>

                            <div class="form-group">
                                <label for="address">Dirección *</label>
                                <input type="text" id="address" name="address" placeholder="Calle, número, colonia" required>
                                <div class="input-focus-effect"></div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="city">Ciudad *</label>
                                    <input type="text" id="city" name="city" required>
                                    <div class="input-focus-effect"></div>
                                </div>
                                <div class="form-group">
                                    <label for="state">Estado *</label>
                                    <select id="state" name="state" required>
                                        <option value="">Seleccionar estado</option>
                                        <option value="CDMX">Ciudad de México</option>
                                        <option value="JAL">Jalisco</option>
                                        <option value="NL">Nuevo León</option>
                                        <option value="BC">Baja California</option>
                                        <option value="SON">Sonora</option>
                                    </select>
                                    <div class="input-focus-effect"></div>
                                </div>
                                <div class="form-group">
                                    <label for="zipCode">Código Postal *</label>
                                    <input type="text" id="zipCode" name="zipCode" required>
                                    <div class="input-focus-effect"></div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="country">País *</label>
                                <select id="country" name="country" required>
                                    <option value="MX">México</option>
                                    <option value="US">Estados Unidos</option>
                                    <option value="CA">Canadá</option>
                                </select>
                                <div class="input-focus-effect"></div>
                            </div>
                        </div>

                        <!-- Billing Address -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="fas fa-receipt"></i>
                                <h3>Dirección de Facturación</h3>
                               <!-- <label class="checkbox-container">
                                    <input type="checkbox" id="sameAsShipping" checked onchange="toggleBillingAddress()">
                                    <span class="checkmark"></span>
                                    Igual que dirección de envío
                                </label>-->
                            </div>

                            <div id="billingAddressFields" style="display: none;">
                                <div class="form-group">
                                    <label for="billingAddress">Dirección de Facturación *</label>
                                    <input type="text" id="billingAddress" name="billingAddress" placeholder="Calle, número, colonia">
                                    <div class="input-focus-effect"></div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="billingCity">Ciudad *</label>
                                        <input type="text" id="billingCity" name="billingCity">
                                        <div class="input-focus-effect"></div>
                                    </div>
                                    <div class="form-group">
                                        <label for="billingState">Estado *</label>
                                        <select id="billingState" name="billingState">
                                            <option value="">Seleccionar estado</option>
                                            <option value="CDMX">Ciudad de México</option>
                                            <option value="JAL">Jalisco</option>
                                            <option value="NL">Nuevo León</option>
                                        </select>
                                        <div class="input-focus-effect"></div>
                                    </div>
                                    <div class="form-group">
                                        <label for="billingZipCode">Código Postal *</label>
                                        <input type="text" id="billingZipCode" name="billingZipCode">
                                        <div class="input-focus-effect"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Shipping Method -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="fas fa-shipping-fast"></i>
                                <h3>Método de Envío</h3>
                            </div>

                            <div class="shipping-options">
                                <label class="shipping-option">
                                    <input type="radio" name="shipping" value="standard" checked>
                                    <div class="option-content">
                                        <div class="option-info">
                                            <h4>Envío Estándar</h4>
                                            <p>5-7 días hábiles</p>
                                        </div>
                                        <div class="option-price">Gratis</div>
                                    </div>
                                </label>

                                <label class="shipping-option">
                                    <input type="radio" name="shipping" value="express">
                                    <div class="option-content">
                                        <div class="option-info">
                                            <h4>Envío Express</h4>
                                            <p>2-3 días hábiles</p>
                                        </div>
                                        <div class="option-price">$199</div>
                                    </div>
                                </label>

                                <label class="shipping-option">
                                    <input type="radio" name="shipping" value="overnight">
                                    <div class="option-content">
                                        <div class="option-info">
                                            <h4>Envío Nocturno</h4>
                                            <p>1 día hábil</p>
                                        </div>
                                        <div class="option-price">$399</div>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <!-- Special Instructions -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="fas fa-comment"></i>
                                <h3>Instrucciones Especiales</h3>
                            </div>

                            <div class="form-group">
                                <label for="instructions">Notas para el envío (opcional)</label>
                                <textarea id="instructions" name="instructions" rows="3" placeholder="Ej: Dejar en portería, tocar timbre, etc."></textarea>
                                <div class="input-focus-effect"></div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="button" class="btn-secondary" onclick="goBack()">
                                <i class="fas fa-arrow-left"></i>
                                Volver al Carrito
                            </button>
                            <button type="submit" class="btn-primary">
                                <span>Continuar al Pago</span>
                                <i class="fas fa-arrow-right"></i>
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
                                <img src="/placeholder.svg?height=80&width=80" alt="Producto">
                                <div class="item-details">
                                    <h4>Laptop Gaming ASUS ROG</h4>
                                    <p>Cantidad: 1</p>
                                    <span class="item-price">$1,299.99</span>
                                </div>
                            </div>

                            <div class="order-item">
                                <img src="/placeholder.svg?height=80&width=80" alt="Producto">
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
                                <span>Envío:</span>
                                <span id="shippingCost">Gratis</span>
                            </div>
                            <div class="total-line">
                                <span>Impuestos:</span>
                                <span>$127.99</span>
                            </div>
                            <div class="total-line total">
                                <span>Total:</span>
                                <span id="finalTotal">$1,727.97</span>
                            </div>
                        </div>

                        <div class="promo-code">
                            <div class="promo-input">
                                <input type="text" placeholder="Código de descuento" id="promoCode">
                                <button type="button" onclick="applyPromoCode()">Aplicar</button>
                            </div>
                        </div>

                        <div class="security-badges">
                            <div class="security-badge">
                                <i class="fas fa-shield-alt"></i>
                                <span>Compra Segura</span>
                            </div>
                            <div class="security-badge">
                                <i class="fas fa-truck"></i>
                                <span>Envío Garantizado</span>
                            </div>
                            <div class="security-badge">
                                <i class="fas fa-undo"></i>
                                <span>30 días de devolución</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Saved Addresses Modal -->
    <!--<div id="savedAddressesModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Direcciones Guardadas</h3>
                <button class="modal-close" onclick="closeSavedAddresses()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="saved-addresses">
                    <div class="saved-address" onclick="selectAddress('home')">
                        <div class="address-info">
                            <h4>Casa</h4>
                            <p>Av. Principal 123, Apt 4B<br>Ciudad de México, CDMX 01234</p>
                        </div>
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="saved-address" onclick="selectAddress('office')">
                        <div class="address-info">
                            <h4>Oficina</h4>
                            <p>Torre Empresarial, Piso 15<br>Av. Reforma 456, CDMX 01235</p>
                        </div>
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>-->

    <script src="Scripts/pedido.js"></script>
</body>
</html>
