<%@ Page Title="Catálogo de Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="EcommerceComputadorasNW.Productos" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

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

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .products-grid.list-view {
            grid-template-columns: 1fr;
        }

        .product-card.list-view {
            display: grid;
            grid-template-columns: 200px 1fr auto;
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

        .filters-sidebar {
            position: sticky;
            top: 100px;
            height: fit-content;
            max-width: 300px;
        }

        .filter-card {
            background: #fff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
            border: 1px solid #e5e7eb;
            transition: all 0.3s ease;
        }

        .filter-card:hover {
            box-shadow: 0 6px 24px rgba(0, 0, 0, 0.08);
        }

        .filter-card h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 25px;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-group {
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 1px solid #e5e7eb;
        }

        .filter-group h4 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--text-primary);
            border-left: 4px solid var(--primary-color);
            padding-left: 10px;
        }


        .price-inputs {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .price-input {
            flex: 1;
            padding: 8px 10px;
            border-radius: 8px;
            border: 2px solid #d1d5db;
            font-size: 14px;
            min-width: 0;
            box-sizing: border-box;
        }

        .price-input:focus {
            border-color: var(--primary-color);
            outline: none;
        }

        .price-inputs span {
            font-weight: bold;
            color: #6b7280;
            font-size: 16px;
        }

        .filter-options input[type="checkbox"] {
            margin-right: 8px;
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .filter-options .aspNet-CheckBoxList label {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 6px 0;
            font-size: 14px;
            color: #374151;
            cursor: pointer;
        }

        .filter-options .aspNet-CheckBoxList {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .filter-options input[type="checkbox"]:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .filter-options input[type="checkbox"]:checked::after {
            content: '';
            position: absolute;
            top: 3px;
            left: 6px;
            width: 4px;
            height: 8px;
            border: solid white;
            border-width: 0 2px 2px 0;
            transform: rotate(45deg);
        }


        .filter-options label {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            color: #374151;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .filter-options label:hover {
            transform: translateX(5px);
        }


        .filter-option .stars {
            color: var(--secondary-color);
            font-size: 14px;
            margin-left: 4px;
        }


        .clear-filters-btn {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            font-weight: 600;
            background: linear-gradient(to right, #f87171, #ef4444);
            color: white;
            border: none;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .clear-filters-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(239, 68, 68, 0.3);
        }

        .asp-checkbox-list {
            display: table;
            width: 100%;
        }

        .asp-checkbox-list td {
            padding: 6px 0;
            vertical-align: middle;
        }

        .asp-checkbox-list input[type="checkbox"] {
            margin-right: 8px;
            transform: scale(1.1);
            cursor: pointer;
        }

        .asp-checkbox-list label {
            font-size: 14px;
            color: #374151;
            cursor: pointer;
        }

        @media (max-width: 768px) {
            .filters-sidebar {
                position: relative;
                top: 0;
                margin-bottom: 30px;
            }

            .catalog-layout {
                flex-direction: column;
            }
        }
    </style>
      <link rel="stylesheet" href="registrologin.css" />

    <!-- Header de la Página -->
    <section class="page-header">
        <div class="container">
            <div class="page-header-content">
                <h1>Catálogo de Productos</h1>
                <p>Descubre nuestra amplia selección de computadoras y tecnología</p>
                <div class="breadcrumb">
                    <a href="Default.aspx">Inicio</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Catálogo</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Sección de Productos y Filtros -->
    <section class="catalog-section">
        <div class="container">
            <div class="catalog-layout">

                <!-- Filtros de Barra Lateral -->
                <aside class="filters-sidebar">
                    <div class="filter-card">
                        <h3><i class="fas fa-filter"></i> Filtros</h3>

                        <!-- Filtro de Rango de Precio -->
                        <div class="filter-group">
                            <h4>Rango de Precio</h4>
                            <div class="price-inputs">
                                <asp:TextBox ID="txtMinPrecio" runat="server" AutoPostBack="true" CssClass="price-input" OnTextChanged="Filtros_Changed" />
                                <span>-</span>
                                <asp:TextBox ID="txtMaxPrecio" runat="server" AutoPostBack="true" CssClass="price-input" OnTextChanged="Filtros_Changed" />
                            </div>
                        </div>

                        <!-- Filtro de Categoría -->
                        <div class="filter-group">
                            <h4>Categoría</h4>
                            <asp:CheckBoxList ID="cblCategorias" runat="server" 
                                  RepeatLayout="Table"
                                  RepeatDirection="Vertical"
                                  CssClass="asp-checkbox-list"
                                  AutoPostBack="true" OnSelectedIndexChanged="Filtros_Changed" />
                        </div>

                        <!-- Filtro de Marca -->
                        <div class="filter-group">
                            <h4>Marca</h4>
                            <asp:CheckBoxList ID="cblMarcas" runat="server" 
                                  RepeatLayout="Table"
                                  RepeatDirection="Vertical"
                                  CssClass="asp-checkbox-list"
                                  AutoPostBack="true" OnSelectedIndexChanged="Filtros_Changed" />
                        </div>

                        <!--<div class="filter-group">
                            <h4>Calificación</h4>
                            <div class="filter-options">
                                <label class="filter-option">
                                    <input type="checkbox" value="5" onchange="applyFilters()" />
                                    <span class="stars">★★★★★</span>
                                    <span class="count">(15)</span>
                                </label>
                                <label class="filter-option">
                                    <input type="checkbox" value="4" onchange="applyFilters()" />
                                    <span class="stars">★★★★☆</span>
                                    <span class="count">(23)</span>
                                </label>
                                <label class="filter-option">
                                    <input type="checkbox" value="3" onchange="applyFilters()" />
                                    <span class="stars">★★★☆☆</span>
                                    <span class="count">(8)</span>
                                </label>
                            </div>
                        </div>-->

                        <!-- Botón para Limpiar Filtros -->
                        <button class="clear-filters-btn" onclick="clearFilters()">
                            <i class="fas fa-times"></i> Limpiar Filtros
                        </button>
                    </div>
                </aside>

                <!-- Área de Productos -->
                <main class="products-area">
                    <!-- Encabezado de Productos -->
                    <div class="products-header">
                        <div class="products-info">
                            <h2>Productos</h2>
                            <span class="products-count">Mostrando <span id="productsCount" runat="server" ClientIDMode="Static">0</span> productos</span>
                        </div>
                        <div class="products-controls">
                            <div class="sort-control">
                                <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Filtros_Changed">
                                    <asp:ListItem Text="Relevancia" Value="relevance" />
                                    <asp:ListItem Text="Precio: Menor a Mayor" Value="price-low" />
                                    <asp:ListItem Text="Precio: Mayor a Menor" Value="price-high" />
                                    <asp:ListItem Text="Mejor Calificación" Value="rating" />
                                    <asp:ListItem Text="Más Recientes" Value="newest" />
                                </asp:DropDownList>
                              </div>
                           <div class="view-controls">
                            <button type="button" class="view-btn active" data-view="grid" onclick="changeView('grid')">
                                <i class="fas fa-th-large"></i>
                            </button>
                            <button type="button" class="view-btn" data-view="list" onclick="changeView('list')">
                                <i class="fas fa-list"></i>
                            </button>
                        </div>
                        </div>
                    </div>

                    <!-- Grid de Productos -->
                  <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                  <asp:UpdatePanel ID="upProductos" runat="server" UpdateMode="Conditional">
                  <ContentTemplate>
                    <div class="products-grid" id="productsGrid" runat="server" ClientIDMode="Static">
                        <asp:Repeater ID="rptProductos" runat="server">
                            <ItemTemplate>
                                <div class="product-card">
                                    <div class="product-image">
                                        <img src='<%# "img/" + Eval("ImaPro") %>' alt='<%# Eval("NomPro") %>' />
                                        <div class="product-overlay">
                                            <button class="quick-view-btn">
                                                <i class="fas fa-eye"></i> Vista rápida
                                            </button>
                                        </div>
                                    </div>
                                    <div class="product-info">
                                        <div class="product-category"><%# Eval("NomCat") %></div>
                                        <h3 class="product-title"><%# Eval("NomPro") %></h3>
                                        <p class="product-description"><%# Eval("DescPro") %></p>
                                        <div class="product-rating">
                                            <div class="stars">
                                                <%# ((EcommerceComputadorasNW.Productos)this.Page).GenerarEstrellas(Convert.ToDecimal(Eval("RatingPro"))) %>
                                            </div>
                                            <span class="rating-count">(<%# Eval("ReviewsPro") %>)</span>
                                        </div>
                                        <div class="product-price">$<%# String.Format("{0:F2}", Eval("PrePro")) %></div>
                                        <div class="product-actions">
                                        <asp:Button ID="btnAgregarCarrito" runat="server" Text="Agregar al carrito"
                                            CommandArgument='<%# Eval("ProID") %>' CommandName="Agregar"
                                            CssClass="add-to-cart" OnCommand="btnAgregarCarrito_Command" />
                                            <button class="wishlist-btn">
                                                <i class="far fa-heart"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </ContentTemplate>
                </asp:UpdatePanel>

                    <!-- Paginación -->
                    <div class="pagination">
                        <button class="pagination-btn" onclick="changePage('prev')">
                            <i class="fas fa-chevron-left"></i> Anterior
                        </button>
                        <div class="page-numbers">
                            <button class="page-btn active">1</button>
                            <button class="page-btn">2</button>
                            <button class="page-btn">3</button>
                            <span>...</span>
                            <button class="page-btn">8</button>
                        </div>
                        <button class="pagination-btn" onclick="changePage('next')">
                            Siguiente <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>

                    <asp:DropDownList ID="ddlCategoria" runat="server" style="display:none;"></asp:DropDownList>
                    <asp:DropDownList ID="ddlMarca" runat="server" style="display:none;"></asp:DropDownList>
                    <asp:DropDownList ID="ddlOrdenar" runat="server" style="display:none;"></asp:DropDownList>

                    <span id="Span1" runat="server" ClientIDMode="Static" style="display:none;">0</span>
                </main>
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
    <script src="Scripts/catalogo.js"></script>
</asp:Content>