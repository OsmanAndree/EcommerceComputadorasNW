<%@ Page Title="Carrito" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Carrito.aspx.cs" Inherits="EcommerceComputadorasNW.Carrito" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .cart-item {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px;
            background: #fff;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .cart-item-image img {
            width: 120px;
            height: auto;
            border-radius: 10px;
            object-fit: cover;
        }

        .cart-item-info {
            flex: 1;
        }

        .cart-item-title {
            font-size: 18px;
            font-weight: bold;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .cart-item-price,
        .cart-item-quantity,
        .cart-item-subtotal {
            font-size: 14px;
            margin: 4px 0;
            color: #4b5563;
        }

    </style>

    <!-- Page Header -->
    <section class="page-header">
        <div class="container">
            <div class="page-header-content">
                <h1>Carrito de Compras</h1>
                <p>Revisa tus productos y completa tu compra</p>
                <div class="breadcrumb">
                    <a href="index.html">Inicio</a>
                    <i class="fas fa-chevron-right"></i>
                    <a href="catalogo.html">Catálogo</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Carrito</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Cart Section -->
    <section class="cart-section">
        <div class="container">
            <div class="cart-layout">
                <!-- Cart Items -->
                <main class="cart-items">
                    <div class="cart-header">
                        <h2>Productos en el carrito</h2>
                        <span class="items-count">(<span id="cartItemsCount">0</span> productos)</span>
                    </div>

                    <!-- Empty Cart Message -->
                    <div id="emptyCart" class="empty-cart" style="display: none;">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>Tu carrito está vacío</h3>
                        <p>Agrega algunos productos para comenzar tu compra</p>
                        <a href="catalogo.html" class="continue-shopping-btn">
                            <i class="fas fa-arrow-left"></i> Continuar Comprando
                        </a>
                    </div>
                     <asp:Panel ID="pnlCompraExitosa" runat="server" Visible="false" CssClass="text-center" style="padding: 60px 0;">
                        <div style="font-size: 70px; color: #28a745;"><i class="fas fa-check-circle"></i></div>
                        <h2 style="margin-top: 20px;">¡Compra realizada con éxito!</h2>
                        
                    </asp:Panel>
                    <!-- Cart Items List -->
                   <asp:Repeater ID="rptCarrito" runat="server">
                        <ItemTemplate>
                            <div class="cart-item">
                                <div class="cart-item-image">
                                    <img src='<%# "img/" + Eval("ImaPro") %>' alt='<%# Eval("Nombre") %>' />
                                </div>
                                <div class="cart-item-info">
                                    <h4 class="cart-item-title"><%# Eval("Nombre") %></h4>
                                    <p class="cart-item-price">Precio: $<%# Eval("Precio", "{0:F2}") %></p>
                                    <p class="cart-item-quantity">Cantidad: <%# Eval("Cantidad") %></p>
                                    <p class="cart-item-subtotal">Subtotal: $<%# Eval("Subtotal", "{0:F2}") %></p>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>


                    <asp:Panel ID="pnlCarritoVacio" runat="server" Visible="true">
                        <div id="emptyCart" class="empty-cart">
                            <i class="fas fa-shopping-cart"></i>
                            <h3>Tu carrito está vacío</h3>
                            <p>Agrega algunos productos para comenzar tu compra</p>
                            <a href="Productos.aspx" class="continue-shopping-btn">
                                <i class="fas fa-arrow-left"></i> Continuar Comprando
                            </a>
                        </div>
                    </asp:Panel>


                    <!-- Cart Actions -->
                    <div class="cart-actions">
                        <a href="Productos.aspx" class="continue-shopping-btn">
                            <i class="fas fa-arrow-left"></i> Continuar Comprando
                        </a>
                        <button class="clear-cart-btn" onclick="clearCart()">
                            <i class="fas fa-trash"></i> Vaciar Carrito
                        </button>
                    </div>
                </main>

                <!-- Order Summary -->
                <aside class="order-summary">
                    <div class="summary-card">
                        <h3><i class="fas fa-receipt"></i> Resumen de la Orden</h3>
                        
                        <!-- Coupon Code -->
                        <div class="coupon-section">
                            <h4>Código de Descuento</h4>
                            <div class="coupon-input">
                                <input type="text" id="couponCode" placeholder="Ingresa tu código">
                                <button onclick="applyCoupon()">Aplicar</button>
                            </div>
                            <div id="couponMessage" class="coupon-message"></div>
                        </div>

                        <!-- Summary Details -->
                        <div class="summary-details">
                            <div class="summary-row">
                                <span>Subtotal:</span>
                                <span id="subtotal" runat="server">$0.00</span>
                            </div>
                            <div class="summary-row">
                                <span>Descuento:</span>
                                <span id="discount" runat="server">-$0.00</span>
                            </div>
                            <div class="summary-row">
                                <span>Envío:</span>
                                <span id="shipping" runat="server">$0.00</span>
                            </div>
                            <div class="summary-row total">
                                <span>Total:</span>
                                <span id="total" runat="server">$0.00</span>
                            </div>
                        </div>

                        <!-- Shipping Options -->
                        <div class="shipping-options">
                            <h4>Opción de Envío</h4>
                            <div class="shipping-option">
                                <input type="radio" id="standard" name="shipping" value="standard" checked>
                                <label for="standard">
                                    <div class="shipping-info">
                                        <span class="shipping-name">Envío Estándar</span>
                                        <span class="shipping-desc">5-7 días hábiles</span>
                                    </div>
                                    <span class="shipping-price">$0.00</span>
                                </label>
                            </div>
                            <div class="shipping-option">
                                <input type="radio" id="express" name="shipping" value="express">
                                <label for="express">
                                    <div class="shipping-info">
                                        <span class="shipping-name">Envío Express</span>
                                        <span class="shipping-desc">2-3 días hábiles</span>
                                    </div>
                                    <span class="shipping-price">$15.00</span>
                                </label>
                            </div>
                            <div class="shipping-option">
                                <input type="radio" id="overnight" name="shipping" value="overnight">
                                <label for="overnight">
                                    <div class="shipping-info">
                                        <span class="shipping-name">Envío Nocturno</span>
                                        <span class="shipping-desc">1 día hábil</span>
                                    </div>
                                    <span class="shipping-price">$25.00</span>
                                </label>
                            </div>
                        </div>

                        <!-- Checkout Button -->
                        <asp:Button ID="btnPagar" runat="server" CssClass="checkout-btn" Text="Proceder al Pago" OnClick="btnPagar_Click" />


                        <!-- Security Info -->
                        <div class="security-info">
                            <i class="fas fa-shield-alt"></i>
                            <span>Compra 100% segura con encriptación SSL</span>
                        </div>

                        <!-- Payment Methods -->
                        <div class="payment-methods">
                            <span>Aceptamos:</span>
                            <div class="payment-icons">
                                <i class="fab fa-cc-visa"></i>
                                <i class="fab fa-cc-mastercard"></i>
                                <i class="fab fa-cc-paypal"></i>
                                <i class="fab fa-cc-amex"></i>
                            </div>
                        </div>
                    </div>
                </aside>
            </div>
        </div>
    </section>

    <!-- Newsletter -->
    <section class="newsletter">
        <div class="container">
            <h2>Suscríbete a nuestro newsletter</h2>
            <p>Recibe las mejores ofertas y novedades en tecnología</p>
            <div class="newsletter-form">
                <input type="email" placeholder="Tu email">
                <button>Suscribirse</button>
            </div>
        </div>
    </section>
</asp:Content>
