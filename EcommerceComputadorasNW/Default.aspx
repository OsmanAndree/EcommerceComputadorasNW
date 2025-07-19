<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="EcommerceComputadorasNW._Default" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
     <link rel="stylesheet" href="registrologin.css" />
    <style>
     .product-card {
        background: white;
        border-radius: var(--border-radius);
        overflow: hidden;
        box-shadow: var(--shadow-md);
        transition: all 0.3s ease;
        border: 1px solid rgba(0, 0, 0, 0.05);
        position: relative;
    }

    .product-card::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.05), rgba(236, 72, 153, 0.05));
        opacity: 0;
        transition: opacity 0.3s ease;
        pointer-events: none;
    }

    .product-card:hover::before {
        opacity: 1;
    }

    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-xl);
    }

    .product-card.list-view {
        display: grid;
        grid-template-columns: 200px 1fr auto;
        gap: 20px;
        align-items: center;
        padding: 20px;
    }

    .product-card.list-view .product-image {
        width: 200px;
        height: 150px;
    }

    .product-card.list-view .product-info {
        padding: 0;
    }

    .product-card.list-view .product-actions {
        display: flex;
        flex-direction: column;
        gap: 10px;
        align-items: flex-end;
    }

    .product-image {
        position: relative;
        overflow: hidden;
        height: 200px;
    }

    .product-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
    }

    .product-card:hover .product-image img {
        transform: scale(1.05);
    }

    .product-overlay {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.7);
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .product-card:hover .product-overlay {
        opacity: 1;
    }

    .quick-view-btn {
        background: linear-gradient(135deg, #f59e0b, #ec4899);
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 25px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .quick-view-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(245, 158, 11, 0.4);
    }

    .product-info {
        padding: 20px;
    }

    .product-category {
        font-size: 12px;
        color: var(--primary-color);
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 8px;
    }

    .product-title {
        font-size: 1.1rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 10px;
        line-height: 1.4;
    }

    .product-description {
        font-size: 14px;
        color: var(--text-secondary);
        margin-bottom: 15px;
        line-height: 1.5;
    }

    .product-rating {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 15px;
    }

    .stars {
        color: var(--secondary-color);
        font-size: 14px;
    }

    .rating-count {
        font-size: 12px;
        color: var(--text-secondary);
    }

    .product-price {
        font-size: 1.3rem;
        font-weight: 700;
        color: var(--primary-color);
        margin-bottom: 15px;
    }

    .product-actions {
        display: flex;
        gap: 10px;
    }

    .add-to-cart {
        flex: 1;
        background: linear-gradient(135deg, #f59e0b, #ec4899);
        color: white;
        border: none;
        padding: 12px;
        border-radius: 8px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .add-to-cart::before {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
        transition: left 0.5s;
    }

    .add-to-cart:hover::before {
        left: 100%;
    }

    .add-to-cart:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(245, 158, 11, 0.4);
    }

    .wishlist-btn {
        padding: 12px;
        border: 2px solid #e2e8f0;
        background: white;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
        color: var(--text-secondary);
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .wishlist-btn:hover {
        border-color: var(--accent-color);
        color: var(--accent-color);
        background: rgba(236, 72, 153, 0.05);
    }

    </style>
    <!-- Hero Banner -->
    <section class="hero-banner">
        <div class="banner-content">
            <h2>Las mejores computadoras al mejor precio</h2>
            <p>Encuentra laptops gaming, PCs de oficina y componentes de última generación</p>
            <a href="Productos.aspx" class="cta-button" style="text-decoration: none;">Ver productos</a>
        </div>
        <div class="banner-image">
            <img src="img/setupin.png" alt="Gaming Setup" />
        </div>
    </section>

    <!-- Categorías Destacadas -->
    <section class="featured-categories">
        <div class="container">
            <h2>Categorías destacadas</h2>
            <div class="categories-grid">
                <asp:Repeater ID="rptCategorias" runat="server">
                    <ItemTemplate>
                        <div class="category-card" data-category='<%# Eval("NomCat") %>'>
                            <img src='<%# Eval("ImgCat") %>' alt='<%# Eval("NomCat") %>' />
                            <h3><%# Eval("NomCat") %></h3>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

   <!-- Sección de Productos -->
    <section class="products-section">
        <div class="container">
            <h2>Productos destacados</h2>
            <div class="products-grid">
                <asp:Repeater ID="rptProductos" runat="server">
                    <ItemTemplate>
                        <div class="product-card" style="animation: fadeInUp 0.6s ease-out;">
                            <div class="product-image">
                                <img src='<%# "img/" + Eval("ImaPro") %>' alt='<%# Eval("NomPro") %>' />
                            </div>
                            <div class="product-info">
                                <h3 class="product-title"><%# Eval("NomPro") %></h3>
                                <div class="product-rating">
                                    <div class="stars">
                                        <%# GenerarEstrellas(Convert.ToDecimal(Eval("RatingPro"))) %>
                                    </div>
                                    <span class="rating-count">(<%# Eval("ReviewsPro") %>)</span>
                                </div>
                                <div class="product-price">$<%# String.Format("{0:F2}", Eval("PrePro")) %></div>
                                <a href="Productos.aspx" class="add-to-cart" style="text-decoration: none;">
                                    <i class="fas fa-eye"></i> Ver en catálogo
                                </a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>


    <!-- Newsletter -->
    <section class="newsletter">
        <div class="container">
            <h2>Suscríbete a nuestro newsletter</h2>
            <p>Recibe las mejores ofertas y novedades en tecnología</p>
            <div class="newsletter-form">
                <input type="email" placeholder="Tu email" />
                <button>Suscribirse</button>
            </div>
        </div>
    </section>

</asp:Content>
