<%@ Page Title="Carrito" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Carrito.aspx.cs" Inherits="EcommerceComputadorasNW.Carrito" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .compra-exitosa-panel {
        text-align: center;
        padding: 60px 20px;
        background-color: #f0fdf4;
        border: 2px solid #22c55e;
        border-radius: 16px;
        animation: fadeInZoom 1s ease;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        margin-bottom: 30px;
        }

        .compra-exitosa-icon {
            font-size: 80px;
            color: #22c55e;
            animation: bounceIn 0.8s ease;
        }

        .compra-exitosa-title {
            margin-top: 20px;
            font-size: 28px;
            font-weight: 700;
            color: #14532d;
        }

        @keyframes fadeInZoom {
            0% {
                opacity: 0;
                transform: scale(0.8);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes bounceIn {
            0% {
                transform: scale(0.3);
                opacity: 0;
            }
            50% {
                transform: scale(1.05);
                opacity: 1;
            }
            70% {
                transform: scale(0.9);
            }
            100% {
                transform: scale(1);
            }
        }
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

    <!-- Header de la Página -->
    <section class="page-header">
        <div class="container">
            <div class="page-header-content">
                <h1>Carrito de Compras</h1>
                <p>Revisa tus productos y completa tu compra</p>
                <div class="breadcrumb">
                    <a href="Default.aspx">Inicio</a>
                    <i class="fas fa-chevron-right"></i>
                    <a href="Productos.aspx">Catálogo</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Carrito</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Sección del Carrito -->
    <section class="cart-section">
        <div class="container">
            <div class="cart-layout">
                <!-- Cart Items -->
                <main class="cart-items">
                    <div class="cart-header">
                        <h2>Productos en el carrito</h2>
                    </div>

                    <!-- Mensaje de Carrito Vacío -->
                    <!--<div id="emptyCart" class="empty-cart" style="display: none;">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>Tu carrito está vacío</h3>
                        <p>Agrega algunos productos para comenzar tu compra</p>
                        <a href="catalogo.html" class="continue-shopping-btn">
                            <i class="fas fa-arrow-left"></i> Continuar Comprando
                        </a>
                    </div>-->

                     <!-- <asp:Panel ID="pnlCompraExitosa" runat="server" Visible="false" CssClass="compra-exitosa-panel">
                        <div class="compra-exitosa-icon"><i class="fas fa-check-circle"></i></div>
                        <h2 class="compra-exitosa-title">¡Compra realizada con éxito!</h2>
                    </asp:Panel>-->

                    <!-- Lista de Items del Carrito -->
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


                    <asp:Panel ID="pnlCartActions" runat="server" CssClass="cart-actions" Visible="false">
                        <a href="Productos.aspx" class="continue-shopping-btn">
                            <i class="fas fa-arrow-left"></i> Continuar Comprando
                        </a>
                        <asp:Button ID="btnVaciarCarrito" runat="server" CssClass="clear-cart-btn" Text="Vaciar Carrito" OnClick="btnVaciarCarrito_Click" />
                    </asp:Panel>

                </main>

                <!-- Resumen de la Orden -->
                <asp:Panel ID="pnlResumen" runat="server" CssClass="order-summary" Visible="false">
                    <div class="summary-card">
                        <h3><i class="fas fa-receipt"></i> Resumen de la Orden</h3>
                        
                        <!-- Cupones -->
                        <div class="coupon-section">
                            <h4>Código de Descuento</h4>
                            <div class="coupon-input">
                                <input type="text" id="couponCode" placeholder="Ingresa tu código">
                                <button onclick="applyCoupon()">Aplicar</button>
                            </div>
                            <div id="couponMessage" class="coupon-message"></div>
                        </div>

                        <!-- Detalles Resumidos -->
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

                        <!-- Opciones de Envío -->
                        <!--<div class="shipping-options">
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
                        </div>-->

                        <!-- Botón de Pagar -->
                        <asp:Button ID="btnPagar" runat="server" CssClass="checkout-btn" Text="Proceder al Pago" OnClick="btnPagar_Click" />


                        <!-- Información de Seguridad -->
                        <div class="security-info">
                            <i class="fas fa-shield-alt"></i>
                            <span>Compra 100% segura con encriptación SSL</span>
                        </div>

                        <!-- Formas de Pago -->
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
                </asp:Panel>
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
