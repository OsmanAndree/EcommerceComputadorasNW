<%@ Page Title="Registro" Language="C#" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="EcommerceComputadorasNW.Registro" %>

<!DOCTYPE html>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cuenta - TechStore</title>
    <link rel="stylesheet" href="Content/Registro.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <asp:Literal ID="litToast" runat="server" EnableViewState="false" />

    <div class="auth-container">
        <!-- Elementos del Fondo -->
        <div class="bg-shapes">
            <div class="shape shape-1"></div>
            <div class="shape shape-2"></div>
            <div class="shape shape-3"></div>
            <div class="floating-elements">
                <div class="floating-element"></div>
                <div class="floating-element"></div>
                <div class="floating-element"></div>
            </div>
        </div>

        <!-- Header -->
        <header class="auth-header">
            <div class="logo">
                <a href="index.html">
                    <i class="fas fa-laptop"></i>
                    <span>TechStore</span>
                </a>
            </div>
        </header>

        <!-- Formulario de Registro -->
        <div class="auth-wrapper">
            <div class="auth-card register-card">
                <div class="auth-card-header">
                    <h1>Crear tu cuenta</h1>
                    <p>Únete a TechStore y descubre las mejores ofertas</p>
                </div>

                <form id="registerForm" runat="server" class="auth-form">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="firstName">
                                <i class="fas fa-user"></i>
                                Nombre
                            </label>
                            <input 
                                type="text" 
                                id="firstName" 
                                runat="server"
                                name="firstName" 
                                required
                                placeholder="Tu nombre"
                            >
                            <div class="input-focus-effect"></div>
                        </div>

                        <div class="form-group">
                            <label for="lastName">
                                <i class="fas fa-user"></i>
                                Apellido
                            </label>
                            <input 
                                type="text" 
                                id="lastName" 
                                runat="server"
                                name="lastName" 
                                required
                                placeholder="Tu apellido"
                            >
                            <div class="input-focus-effect"></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="registerEmail">
                            <i class="fas fa-envelope"></i>
                            Correo electrónico
                        </label>
                        <input 
                            type="email" 
                            id="registerEmail"
                            runat="server"
                            name="email" 
                            required
                            placeholder="tu@email.com"
                        >
                        <div class="input-focus-effect"></div>
                    </div>

                    <div class="form-group">
                        <label for="registerPassword">
                            <i class="fas fa-lock"></i>
                            Contraseña
                        </label>
                        <div class="password-input">
                            <input 
                                type="password" 
                                id="registerPassword"
                                runat="server"
                                name="password" 
                                required
                                placeholder="Mínimo 8 caracteres"
                            >
                            <button type="button" class="password-toggle" onclick="togglePassword('registerPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="input-focus-effect"></div>
                        <div class="password-strength" id="passwordStrength">
                            <div class="strength-bar">
                                <div class="strength-fill"></div>
                            </div>
                            <span class="strength-text">Ingresa una contraseña</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">
                            <i class="fas fa-lock"></i>
                            Confirmar contraseña
                        </label>
                        <div class="password-input">
                            <input 
                                type="password" 
                                id="confirmPassword"
                                runat="server"
                                name="confirmPassword" 
                                required
                                placeholder="Confirma tu contraseña"
                            >
                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="input-focus-effect"></div>
                    </div>

                    <div class="form-group">
                        <label for="phone">
                            <i class="fas fa-phone"></i>
                            Teléfono (opcional)
                        </label>
                        <input 
                            type="tel" 
                            id="phone"
                            runat="server"
                            name="phone"
                            placeholder="+1 (555) 123-4567"
                        >
                        <div class="input-focus-effect"></div>
                    </div>

                    <div class="form-options">
                        <label class="checkbox-container">
                            <input type="checkbox" id="terms" required>
                            <span class="checkmark"></span>
                            Acepto los <a href="#" class="terms-link">términos y condiciones</a>
                        </label>
                    </div>

                    <div class="form-options">
                        <label class="checkbox-container">
                            <input type="checkbox" id="newsletter">
                            <span class="checkmark"></span>
                            Quiero recibir ofertas y novedades por email
                        </label>
                    </div>

                    <asp:Button ID="btnRegistrar" runat="server" Text="Crear Cuenta" CssClass="auth-button primary" OnClick="btnRegistrar_Click" />
                </form>

                <div class="divider">
                    <span>O regístrate con</span>
                </div>

                <div class="social-login">
                    <button class="social-button google" onclick="socialLogin('google')">
                        <i class="fab fa-google"></i>
                        <span>Google</span>
                    </button>
                    <button class="social-button facebook" onclick="socialLogin('facebook')">
                        <i class="fab fa-facebook-f"></i>
                        <span>Facebook</span>
                    </button>
                    <button class="social-button github" onclick="socialLogin('github')">
                        <i class="fab fa-github"></i>
                        <span>GitHub</span>
                    </button>
                </div>

                <div class="auth-footer">
                    <p>¿Ya tienes una cuenta? <a href="Login.aspx">Inicia sesión aquí</a></p>
                </div>
            </div>
        </div>
    </div>

    <script src="Scripts/register.js"></script>
</body>
</html>

