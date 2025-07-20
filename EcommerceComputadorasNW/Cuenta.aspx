<%@ Page Title="Mi Cuenta" Language="C#" AutoEventWireup="true" CodeBehind="Cuenta.aspx.cs" Inherits="EcommerceComputadorasNW.Cuenta" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Cuenta - TechStore</title>
    <link rel="stylesheet" href="Content/cuenta.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <form id="form1" runat="server">

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
                
                 <nav class="header-nav">
                     <a href="Default.aspx">Inicio</a>
                     <a href="Cuenta.aspx" class="active">Mi Cuenta</a>
                     <a href="Carrito.aspx">Carrito</a>
                  </nav>

                <div class="header-actions">
                        <div class="user-menu">
                            <!--<div class="user-avatar">
                                <img src="/placeholder.svg?height=40&width=40" alt="Usuario" />
                                <div class="status-indicator"></div>
                            </div>-->
                            <span><asp:Label ID="lblNomUsu" runat="server" /></span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                    </div>
                </div>
            </div>
    </header>

    <!-- Contenido Principal -->
    <main class="main-content">
        <div class="container">
            <div class="account-layout">
                <!-- Sidebar Navigation -->
                <aside class="account-sidebar">
                    <div class="sidebar-header">
                        <div class="user-info">
                            <!--<div class="user-avatar-large">
                                <img src="/placeholder.svg?height=80&width=80" alt="Usuario">
                                <button class="avatar-edit-btn">
                                    <i class="fas fa-camera"></i>
                                </button>
                            </div>-->
                            <div class="user-details">
                                    <h3><asp:Label ID="lblNombreCompleto" runat="server" /></h3>
                                    <p><asp:Label ID="lblCorreo" runat="server" /></p>
                                    <span class="user-badge">Cliente</span>
                             </div>
                        </div>
                    </div>

                    <nav class="sidebar-nav">
                        <a href="#" class="nav-item active" data-section="profile">
                            <i class="fas fa-user"></i>
                            <span>Mi Perfil</span>
                        </a>
                        <!--<a href="#" class="nav-item" data-section="orders">
                            <i class="fas fa-shopping-bag"></i>
                            <span>Mis Pedidos</span>
                            <span class="badge">3</span>
                        </a>
                        <a href="#" class="nav-item" data-section="addresses">
                            <i class="fas fa-map-marker-alt"></i>
                            <span>Direcciones</span>
                        </a>
                        <a href="#" class="nav-item" data-section="payments">
                            <i class="fas fa-credit-card"></i>
                            <span>Métodos de Pago</span>
                        </a>
                        <a href="#" class="nav-item" data-section="wishlist">
                            <i class="fas fa-heart"></i>
                            <span>Lista de Deseos</span>
                            <span class="badge">5</span>
                        </a>
                        <a href="#" class="nav-item" data-section="security">
                            <i class="fas fa-shield-alt"></i>
                            <span>Seguridad</span>
                        </a>
                        <a href="#" class="nav-item" data-section="notifications">
                            <i class="fas fa-bell"></i>
                            <span>Notificaciones</span>
                        </a>-->
                        <a href="Login.aspx" class="nav-item logout" onclick="logout()">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Cerrar Sesión</span>
                        </a>
                    </nav>
                </aside>

                <!-- Area del Contenido Principal -->
                <div class="account-content">
                        <section id="profile" class="content-section active">
                            <div class="section-header">
                                <h2>Mi Perfil</h2>
                                <p>Información personal del usuario</p>
                            </div>

                            <div class="profile-card">
                                <div class="card-header">
                                    <h3>Información Personal</h3>
                                </div>
                                <div class="profile-form">
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>Nombre de Usuario</label>
                                            <input type="text" value='<%: Session["NomUsu"] %>' readonly />
                                        </div>
                                        <div class="form-group">
                                            <label>Email</label>
                                            <input type="email" value='<%: Session["CorUsu"] %>' readonly />
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>Teléfono</label>
                                            <input type="text" value='<%: Session["TelUsu"] %>' readonly />
                                        </div>
                                        <div class="form-group">
                                            <label>Rol</label>
                                            <input type="text" value='<%: Session["RolUsu"] %>' readonly />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!--<div class="profile-card">
                            <div class="card-header">
                                <h3>Estadísticas de Cuenta</h3>
                            </div>
    
                            <div class="stats-grid">
                                <div class="stat-item">
                                    <div class="stat-icon">
                                        <i class="fas fa-shopping-cart"></i>
                                    </div>
                                    <div class="stat-info">
                                        <span class="stat-number">24</span>
                                        <span class="stat-label">Pedidos Totales</span>
                                    </div>
                                </div>
        
                                <div class="stat-item">
                                    <div class="stat-icon">
                                        <i class="fas fa-dollar-sign"></i>
                                    </div>
                                    <div class="stat-info">
                                        <span class="stat-number">$3,450</span>
                                        <span class="stat-label">Total Gastado</span>
                                    </div>
                                </div>
        
                                <div class="stat-item">
                                    <div class="stat-icon">
                                        <i class="fas fa-heart"></i>
                                    </div>
                                    <div class="stat-info">
                                        <span class="stat-number">12</span>
                                        <span class="stat-label">Favoritos</span>
                                    </div>
                                </div>
        
                                <div class="stat-item">
                                    <div class="stat-icon">
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <div class="stat-info">
                                        <span class="stat-number">4.8</span>
                                        <span class="stat-label">Puntuación</span>
                                    </div>
                                </div>
                            </div>
                        </div>-->

                        </section>
                        <!-- Sección de Órdenes 
                        <!--<section id="orders" class="content-section">
                            <div class="section-header">
                                <h2>Mis Pedidos</h2>
                                <p>Historial de todas tus compras</p>
                            </div>

                            <div class="orders-filters">
                                <button class="filter-btn active" data-filter="all">Todos</button>
                                <button class="filter-btn" data-filter="pending">Pendientes</button>
                                <button class="filter-btn" data-filter="shipped">Enviados</button>
                                <button class="filter-btn" data-filter="delivered">Entregados</button>
                            </div>

                            <div class="orders-list">
                                <div class="order-card">
                                    <div class="order-header">
                                        <div class="order-info">
                                            <h4>Pedido #TS-2024-001</h4>
                                            <span class="order-date">15 de Marzo, 2024</span>
                                        </div>
                                        <div class="order-status delivered">
                                            <i class="fas fa-check-circle"></i>
                                            Entregado
                                        </div>
                                    </div>
            
                                    <div class="order-items">
                                        <div class="order-item">
                                            <img src="/placeholder.svg?height=60&width=60" alt="Producto">
                                            <div class="item-details">
                                                <h5>Laptop Gaming ASUS ROG</h5>
                                                <p>Cantidad: 1</p>
                                            </div>
                                            <div class="item-price">$1,299.99</div>
                                        </div>
                                    </div>
            
                                    <div class="order-footer">
                                        <div class="order-total">
                                            <strong>Total: $1,299.99</strong>
                                        </div>
                                        <div class="order-actions">
                                            <button class="btn-outline">Ver Detalles</button>
                                            <button class="btn-outline">Descargar Factura</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="order-card">
                                    <div class="order-header">
                                        <div class="order-info">
                                            <h4>Pedido #TS-2024-002</h4>
                                            <span class="order-date">22 de Marzo, 2024</span>
                                        </div>
                                        <div class="order-status shipped">
                                            <i class="fas fa-truck"></i>
                                            En Camino
                                        </div>
                                    </div>
            
                                    <div class="order-items">
                                        <div class="order-item">
                                            <img src="/placeholder.svg?height=60&width=60" alt="Producto">
                                            <div class="item-details">
                                                <h5>MacBook Pro 14"</h5>
                                                <p>Cantidad: 1</p>
                                            </div>
                                            <div class="item-price">$1,999.99</div>
                                        </div>
                                    </div>
            
                                    <div class="order-footer">
                                        <div class="order-total">
                                            <strong>Total: $1,999.99</strong>
                                        </div>
                                        <div class="order-actions">
                                            <button class="btn-outline">Rastrear Pedido</button>
                                            <button class="btn-outline">Ver Detalles</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Sección de Direcciones -->
                        <section id="addresses" class="content-section">
                            <div class="section-header">
                                <h2>Mis Direcciones</h2>
                                <p>Gestiona tus direcciones de envío</p>
                                <button class="btn-primary" onclick="openAddressModal()">
                                    <i class="fas fa-plus"></i>
                                    Agregar Dirección
                                </button>
                            </div>

                            <div class="addresses-grid">
                                <div class="address-card default">
                                    <div class="address-header">
                                        <h4>Casa</h4>
                                        <span class="default-badge">Predeterminada</span>
                                    </div>
                                    <div class="address-details">
                                        <p><strong>Juan Pérez</strong></p>
                                        <p>Av. Principal 123, Apt 4B</p>
                                        <p>Ciudad de México, CDMX 01234</p>
                                        <p>México</p>
                                        <p>Tel: +1 (555) 123-4567</p>
                                    </div>
                                    <div class="address-actions">
                                        <button class="btn-outline">Editar</button>
                                        <button class="btn-outline danger">Eliminar</button>
                                    </div>
                                </div>

                                <div class="address-card">
                                    <div class="address-header">
                                        <h4>Oficina</h4>
                                    </div>
                                    <div class="address-details">
                                        <p><strong>Juan Pérez</strong></p>
                                        <p>Torre Empresarial, Piso 15</p>
                                        <p>Av. Reforma 456</p>
                                        <p>Ciudad de México, CDMX 01235</p>
                                        <p>México</p>
                                        <p>Tel: +1 (555) 987-6543</p>
                                    </div>
                                    <div class="address-actions">
                                        <button class="btn-outline">Editar</button>
                                        <button class="btn-outline">Predeterminada</button>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Sección de Método de Pago -->
                        <section id="payments" class="content-section">
                            <div class="section-header">
                                <h2>Métodos de Pago</h2>
                                <p>Gestiona tus tarjetas y métodos de pago</p>
                                <button class="btn-primary" onclick="openPaymentModal()">
                                    <i class="fas fa-plus"></i>
                                    Agregar Método
                                </button>
                            </div>

                            <div class="payment-methods">
                                <div class="payment-card default">
                                    <div class="card-visual">
                                        <div class="card-brand">
                                            <i class="fab fa-cc-visa"></i>
                                        </div>
                                        <div class="card-number">**** **** **** 1234</div>
                                        <div class="card-info">
                                            <span>Juan Pérez</span>
                                            <span>12/26</span>
                                        </div>
                                    </div>
                                    <div class="card-actions">
                                        <span class="default-badge">Predeterminada</span>
                                        <button class="btn-outline">Editar</button>
                                        <button class="btn-outline danger">Eliminar</button>
                                    </div>
                                </div>

                                <div class="payment-card">
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
                                    <div class="card-actions">
                                        <button class="btn-outline">Predeterminada</button>
                                        <button class="btn-outline">Editar</button>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Sección de Lista de Deseo -->
                        <section id="wishlist" class="content-section">
                            <div class="section-header">
                                <h2>Lista de Deseos</h2>
                                <p>Productos que te interesan</p>
                            </div>

                            <div class="wishlist-grid">
                                <div class="wishlist-item">
                                    <div class="item-image">
                                        <img src="/placeholder.svg?height=200&width=200" alt="Producto">
                                        <button class="remove-wishlist">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                    <div class="item-details">
                                        <h4>Gaming Monitor 27"</h4>
                                        <p class="item-price">$299.99</p>
                                        <div class="item-actions">
                                            <button class="btn-primary">Agregar al Carrito</button>
                                            <button class="btn-outline">Ver Detalles</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="wishlist-item">
                                    <div class="item-image">
                                        <img src="/placeholder.svg?height=200&width=200" alt="Producto">
                                        <button class="remove-wishlist">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                    <div class="item-details">
                                        <h4>Mechanical Keyboard</h4>
                                        <p class="item-price">$149.99</p>
                                        <div class="item-actions">
                                            <button class="btn-primary">Agregar al Carrito</button>
                                            <button class="btn-outline">Ver Detalles</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Sección de Seguridad -->
                        <section id="security" class="content-section">
                            <div class="section-header">
                                <h2>Seguridad</h2>
                                <p>Gestiona la seguridad de tu cuenta</p>
                            </div>

                            <div class="security-cards">
                                <div class="security-card">
                                    <div class="card-header">
                                        <h3>Cambiar Contraseña</h3>
                                    </div>
            
                                    <form class="security-form">
                                        <div class="form-group">
                                            <label>Contraseña Actual</label>
                                            <div class="password-input">
                                                <input type="password" placeholder="Ingresa tu contraseña actual">
                                                <button type="button" class="password-toggle">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>
                
                                        <div class="form-group">
                                            <label>Nueva Contraseña</label>
                                            <div class="password-input">
                                                <input type="password" placeholder="Ingresa tu nueva contraseña">
                                                <button type="button" class="password-toggle">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>
                
                                        <div class="form-group">
                                            <label>Confirmar Nueva Contraseña</label>
                                            <div class="password-input">
                                                <input type="password" placeholder="Confirma tu nueva contraseña">
                                                <button type="button" class="password-toggle">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>
                
                                        <button type="submit" class="btn-primary">
                                            Cambiar Contraseña
                                        </button>
                                    </form>
                                </div>

                                <div class="security-card">
                                    <div class="card-header">
                                        <h3>Autenticación de Dos Factores</h3>
                                    </div>
            
                                    <div class="two-factor-status">
                                        <div class="status-info">
                                            <i class="fas fa-shield-alt"></i>
                                            <div>
                                                <h4>2FA Desactivado</h4>
                                                <p>Aumenta la seguridad de tu cuenta</p>
                                            </div>
                                        </div>
                                        <button class="btn-primary">Activar 2FA</button>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Sección de Notificaciones -->
                        <section id="notifications" class="content-section">
                            <div class="section-header">
                                <h2>Notificaciones</h2>
                                <p>Configura tus preferencias de notificación</p>
                            </div>

                            <div class="notifications-settings">
                                <div class="notification-group">
                                    <h3>Email</h3>
                                    <div class="notification-item">
                                        <div class="notification-info">
                                            <h4>Ofertas y Promociones</h4>
                                            <p>Recibe emails sobre ofertas especiales</p>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" checked>
                                            <span class="slider"></span>
                                        </label>
                                    </div>
            
                                    <div class="notification-item">
                                        <div class="notification-info">
                                            <h4>Actualizaciones de Pedidos</h4>
                                            <p>Notificaciones sobre el estado de tus pedidos</p>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" checked>
                                            <span class="slider"></span>
                                        </label>
                                    </div>
                                </div>

                                <div class="notification-group">
                                    <h3>Push</h3>
                                    <div class="notification-item">
                                        <div class="notification-info">
                                            <h4>Notificaciones Push</h4>
                                            <p>Recibe notificaciones en tu navegador</p>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox">
                                            <span class="slider"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </section>-->
                     </div>
            </div>

                    
                </div>
            </main>
    </form>
    <script src="Scripts/cuenta.js"></script>
</body>
</html>
