<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="EcommerceComputadorasNW._Default" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero Banner -->
    <section class="hero-banner">
        <div class="banner-content">
            <h2>Las mejores computadoras al mejor precio</h2>
            <p>Encuentra laptops gaming, PCs de oficina y componentes de última generación</p>
            <button class="cta-button">Ver ofertas</button>
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
            <asp:Repeater ID="rptProductos" runat="server">
                <ItemTemplate>
                    <div class="product-card" style="animation: fadeInUp 0.6s ease-out;">
                        <div class="product-image">
                            <img src='<%# Eval("ImaPro") %>' alt='<%# Eval("NomPro") %>' />
                        </div>
                        <div class="product-info">
                            <h3 class="product-title"><%# Eval("NomPro") %></h3>
                            <%-- Podés mostrar rating y reviews si los tienes en BD, sino ignóralo --%>
                            <div class="product-price">$<%# Eval("PrePro", "{0:N2}") %></div>
                            <button class="add-to-cart" onclick="addToCartFromIndex(<%# Eval("ProID") %>)">
                                <i class="fas fa-cart-plus"></i> Agregar al carrito
                            </button>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
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
