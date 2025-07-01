function changePage(pageNumber) {
    __doPostBack('upProductos', pageNumber);
}

function changeView(view) {
    const productsGrid = document.getElementById("productsGrid");

    productsGrid.className = `products-grid ${view}-view`;

    document.querySelectorAll('.view-btn').forEach(btn => btn.classList.remove('active'));
    document.querySelector(`[data-view="${view}"]`).classList.add('active');

    fetch(location.href + "?view=" + view, {
        method: 'POST',
        headers: {
            "X-Requested-With": "XMLHttpRequest"
        }
    }).then(() => {
        __doPostBack('productsGrid', view); 
    });
}

function applyFilters() {
    const categorias = Array.from(document.querySelectorAll('.filter-group input[type=checkbox]:checked'))
        .filter(el => el.closest('h4').textContent.includes('Categoría'))
        .map(el => el.value);
    const marcas = Array.from(document.querySelectorAll('.filter-group input[type=checkbox]:checked'))
        .filter(el => el.closest('h4').textContent.includes('Marca'))
        .map(el => el.value);

    const minPrice = document.getElementById('minPrice').value || 0;
    const maxPrice = document.getElementById('maxPrice').value || 5000;
    const orden = document.getElementById('sortSelect').value;

    document.getElementById('<%= hfCategoria.ClientID %>').value = categorias[0] || 0;
    document.getElementById('<%= hfMarca.ClientID %>').value = marcas[0] || 0;
    document.getElementById('<%= hfPrecioMin.ClientID %>').value = minPrice;
    document.getElementById('<%= hfPrecioMax.ClientID %>').value = maxPrice;
    document.getElementById('<%= hfOrden.ClientID %>').value = orden;

    document.getElementById('<%= btnFiltrar.ClientID %>').click();
}



let currentProducts = [...catalogProducts];
let filteredProducts = [...catalogProducts];
let currentPage = 1;
let productsPerPage = 8;
let currentView = 'grid';
let cart = [];
let cartCount = 0;

const productsGrid = document.getElementById('productsGrid');
const productsCount = document.getElementById('productsCount');
const cartCountElement = document.querySelector('.cart-count');
const searchInput = document.getElementById('searchInput');
const categoryFilter = document.getElementById('categoryFilter');
const priceRange = document.getElementById('priceRange');
const minPriceInput = document.getElementById('minPrice');
const maxPriceInput = document.getElementById('maxPrice');
const sortSelect = document.getElementById('sortSelect');

document.addEventListener('DOMContentLoaded', () => {
    loadProducts();
    setupEventListeners();
    setupFilters();
    updateProductsCount();
    loadCart();
});

function loadProducts() {
    const startIndex = (currentPage - 1) * productsPerPage;
    const endIndex = startIndex + productsPerPage;
    const productsToShow = filteredProducts.slice(startIndex, endIndex);

    productsGrid.innerHTML = '';

    if (productsToShow.length === 0) {
        productsGrid.innerHTML = `
            <div class="no-products">
                <i class="fas fa-search"></i>
                <h3>No se encontraron productos</h3>
                <p>Intenta ajustar los filtros o realizar una búsqueda diferente</p>
            </div>
        `;
        return;
    }

    productsToShow.forEach((product, index) => {
        const productCard = createProductCard(product, index);
        productsGrid.appendChild(productCard);
    });

    updatePagination();
}

function createProductCard(product, index) {
    const card = document.createElement('div');
    card.className = `product-card ${currentView === 'list' ? 'list-view' : ''}`;
    card.style.animation = `fadeInUp 0.6s ease-out ${index * 0.1}s`;

    card.innerHTML = `
        <div class="product-image">
            <img src="${product.image}" alt="${product.title}">
            <div class="product-overlay">
                <button class="quick-view-btn" onclick="quickView(${product.id})">
                    <i class="fas fa-eye"></i> Vista rápida
                </button>
            </div>
        </div>
        <div class="product-info">
            <div class="product-category">${getCategoryName(product.category)}</div>
            <h3 class="product-title">${product.title}</h3>
            <p class="product-description">${product.description}</p>
            <div class="product-rating">
                <div class="stars">${generateStars(product.rating)}</div>
                <span class="rating-count">(${product.reviews})</span>
            </div>
            <div class="product-price">$${product.price.toFixed(2)}</div>
            <div class="product-actions">
                <button class="add-to-cart" onclick="addToCart(${product.id})">
                    <i class="fas fa-cart-plus"></i> Agregar al carrito
                </button>
                <button class="wishlist-btn" onclick="addToWishlist(${product.id})">
                    <i class="far fa-heart"></i>
                </button>
            </div>
        </div>
    `;

    return card;
}

function getCategoryName(category) {
    const categories = {
        'gaming': 'Gaming',
        'office': 'Oficina',
        'desktop': 'Escritorio',
        'components': 'Componentes',
        'accessories': 'Accesorios'
    };
    return categories[category] || category;
}

// Generate star rating
function generateStars(rating) {
    const fullStars = Math.floor(rating);
    const hasHalfStar = rating % 1 !== 0;
    let stars = '';

    for (let i = 0; i < fullStars; i++) {
        stars += '<i class="fas fa-star"></i>';
    }

    if (hasHalfStar) {
        stars += '<i class="fas fa-star-half-alt"></i>';
    }

    const emptyStars = 5 - Math.ceil(rating);
    for (let i = 0; i < emptyStars; i++) {
        stars += '<i class="far fa-star"></i>';
    }

    return stars;
}

function setupEventListeners() {
    // Search functionality
    searchInput.addEventListener('input', debounce(performSearch, 300));
    
    // Category filter
    categoryFilter.addEventListener('change', applyFilters);
    
    // Price range
    priceRange.addEventListener('input', updatePriceInputs);
    minPriceInput.addEventListener('input', updatePriceRange);
    maxPriceInput.addEventListener('input', updatePriceRange);
    
    // Filter checkboxes
    document.querySelectorAll('.filter-option input').forEach(checkbox => {
        checkbox.addEventListener('change', applyFilters);
    });
    
    // Sort functionality
    sortSelect.addEventListener('change', sortProducts);
}

// Setup filters
function setupFilters() {
    // Set initial price range
    updatePriceInputs();
    
    // Update filter counts
    updateFilterCounts();
}

// Update price inputs based on range slider
function updatePriceInputs() {
    const value = priceRange.value;
    maxPriceInput.value = value;
    applyFilters();
}

// Update price range based on inputs
function updatePriceRange() {
    const min = parseInt(minPriceInput.value) || 0;
    const max = parseInt(maxPriceInput.value) || 3000;
    
    if (max >= min) {
        priceRange.value = max;
        applyFilters();
    }
}

// Apply all filters
function applyFilters() {
    const searchTerm = searchInput.value.toLowerCase();
    const selectedCategory = categoryFilter.value;
    const maxPrice = parseInt(maxPriceInput.value) || 3000;
    const minPrice = parseInt(minPriceInput.value) || 0;
    
    // Get selected filter values
    const selectedCategories = getSelectedCheckboxes('category');
    const selectedBrands = getSelectedCheckboxes('brand');
    const selectedRatings = getSelectedCheckboxes('rating');

    filteredProducts = catalogProducts.filter(product => {
        // Search filter
        const matchesSearch = product.title.toLowerCase().includes(searchTerm) ||
                             product.description.toLowerCase().includes(searchTerm);
        
        // Category filter
        const matchesCategory = !selectedCategory || product.category === selectedCategory;
        
        // Price filter
        const matchesPrice = product.price >= minPrice && product.price <= maxPrice;
        
        // Multiple category filter
        const matchesCategories = selectedCategories.length === 0 || 
                                 selectedCategories.includes(product.category);
        
        // Brand filter
        const matchesBrand = selectedBrands.length === 0 || 
                            selectedBrands.includes(product.brand);
        
        // Rating filter
        const matchesRating = selectedRatings.length === 0 || 
                             selectedRatings.some(rating => Math.floor(product.rating) >= parseInt(rating));

        return matchesSearch && matchesCategory && matchesPrice && 
               matchesCategories && matchesBrand && matchesRating;
    });

    currentPage = 1;
    loadProducts();
    updateProductsCount();
}

// Get selected checkbox values
function getSelectedCheckboxes(type) {
    const checkboxes = document.querySelectorAll(`.filter-option input[value*="${type}"]:checked`);
    return Array.from(checkboxes).map(cb => cb.value);
}

// Perform search
function performSearch() {
    applyFilters();
}

// Sort products
function sortProducts() {
    const sortBy = sortSelect.value;
    
    filteredProducts.sort((a, b) => {
        switch (sortBy) {
            case 'price-low':
                return a.price - b.price;
            case 'price-high':
                return b.price - a.price;
            case 'rating':
                return b.rating - a.rating;
            case 'newest':
                return b.id - a.id;
            default:
                return 0;
        }
    });

    currentPage = 1;
    loadProducts();
}


function changeView(view) {
    // Actualiza botones visuales
    document.querySelectorAll('.view-btn').forEach(btn => btn.classList.remove('active'));
    document.querySelector(`[data-view="${view}"]`).classList.add('active');

    // Cambia la clase del contenedor de productos
    const productsGrid = document.getElementById('productsGrid');
    if (productsGrid) {
        // Elimina cualquier clase anterior de vista
        productsGrid.classList.remove('grid-view', 'list-view');
        // Añade la nueva clase
        productsGrid.classList.add(`${view}-view`);
    }
}

// Change page
function changePage(direction) {
    const totalPages = Math.ceil(filteredProducts.length / productsPerPage);
    
    if (direction === 'prev' && currentPage > 1) {
        currentPage--;
    } else if (direction === 'next' && currentPage < totalPages) {
        currentPage++;
    }
    
    loadProducts();
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Update pagination
function updatePagination() {
    const totalPages = Math.ceil(filteredProducts.length / productsPerPage);
    const pagination = document.querySelector('.pagination');
    
    if (totalPages <= 1) {
        pagination.style.display = 'none';
        return;
    }
    
    pagination.style.display = 'flex';
    
    // Update page numbers
    const pageNumbers = document.querySelector('.page-numbers');
    pageNumbers.innerHTML = '';
    
    for (let i = 1; i <= totalPages; i++) {
        if (i === 1 || i === totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
            const pageBtn = document.createElement('button');
            pageBtn.className = `page-btn ${i === currentPage ? 'active' : ''}`;
            pageBtn.textContent = i;
            pageBtn.onclick = () => {
                currentPage = i;
                loadProducts();
                window.scrollTo({ top: 0, behavior: 'smooth' });
            };
            pageNumbers.appendChild(pageBtn);
        } else if (i === currentPage - 2 || i === currentPage + 2) {
            const ellipsis = document.createElement('span');
            ellipsis.textContent = '...';
            pageNumbers.appendChild(ellipsis);
        }
    }
}

// Update products count
function updateProductsCount() {
    productsCount.textContent = filteredProducts.length;
}

// Update filter counts
function updateFilterCounts() {
    // This would typically be calculated from the actual data
    // For now, we'll use static counts
}

// Clear all filters
function clearFilters() {
    // Reset search
    searchInput.value = '';
    
    // Reset category filter
    categoryFilter.value = '';
    
    // Reset price range
    priceRange.value = 3000;
    minPriceInput.value = '';
    maxPriceInput.value = '';
    updatePriceInputs();
    
    // Reset checkboxes
    document.querySelectorAll('.filter-option input').forEach(checkbox => {
        checkbox.checked = false;
    });
    
    // Reset sort
    sortSelect.value = 'relevance';
    
    // Apply filters
    applyFilters();
}

// Add to cart functionality
function addToCart(productId) {
    const product = catalogProducts.find(p => p.id === productId);
    if (product) {
        const existingItem = cart.find(item => item.id === productId);
        
        if (existingItem) {
            existingItem.quantity += 1;
        } else {
            cart.push({ ...product, quantity: 1 });
        }
        
        cartCount++;
        updateCartCount();
        saveCart();
        showAddToCartAnimation();
        showNotification(`${product.title} agregado al carrito`);
    }
}

// Update cart count display
function updateCartCount() {
    cartCountElement.textContent = cartCount;
    cartCountElement.style.animation = 'none';
    setTimeout(() => {
        cartCountElement.style.animation = 'pulse 0.5s ease-in-out';
    }, 10);
}

// Show add to cart animation
function showAddToCartAnimation() {
    const cartIcon = document.querySelector('.cart');
    cartIcon.style.animation = 'none';
    setTimeout(() => {
        cartIcon.style.animation = 'bounce 0.6s ease-in-out';
    }, 10);
}

// Save cart to localStorage
function saveCart() {
    localStorage.setItem('techstore-cart', JSON.stringify(cart));
    localStorage.setItem('techstore-cart-count', cartCount.toString());
}

// Load cart from localStorage
function loadCart() {
    const savedCart = localStorage.getItem('techstore-cart');
    const savedCount = localStorage.getItem('techstore-cart-count');
    
    if (savedCart) {
        cart = JSON.parse(savedCart);
    }
    
    if (savedCount) {
        cartCount = parseInt(savedCount);
        updateCartCount();
    }
}

// Add to wishlist
function addToWishlist(productId) {
    const product = catalogProducts.find(p => p.id === productId);
    if (product) {
        showNotification(`${product.title} agregado a favoritos`);
    }
}

// Quick view functionality
function quickView(productId) {
    const product = catalogProducts.find(p => p.id === productId);
    if (product) {
        // This would typically open a modal with product details
        showNotification(`Vista rápida de ${product.title}`);
    }
}

// Show notification
function showNotification(message) {
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
        padding: 15px 20px;
        border-radius: 12px;
        z-index: 10000;
        animation: slideInRight 0.3s ease-out;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        font-weight: 600;
    `;

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease-in';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Debounce function
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Add floating animation to elements
function addFloatingAnimation() {
    const elements = document.querySelectorAll('.product-card, .filter-card');
    elements.forEach((element, index) => {
        element.style.animationDelay = `${index * 0.1}s`;
    });
}

// Enhanced scroll animations
function enhancedScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    document.querySelectorAll('.product-card, .filter-card').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
}

// Initialize enhanced features
document.addEventListener('DOMContentLoaded', () => {
    addFloatingAnimation();
    enhancedScrollAnimations();
}); 