<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EcommerceComputadorasNW.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Iniciar Sesión - TechStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            min-width: 250px;
            padding: 15px 20px;
            border-radius: 8px;
            color: #fff;
            font-family: 'Inter', sans-serif;
            font-size: 14px;
            box-shadow: 0 0 12px rgba(0,0,0,0.2);
            z-index: 9999;
            display: none;
            opacity: 0;
            transition: opacity 0.5s ease-in-out;
        }

        .toast-container.show {
            display: block;
            opacity: 1;
        }

        .toast-success {
            background-color: #28a745;
        }

        .toast-error {
            background-color: #dc3545;
        }

        .toast-close {
            background: none;
            border: none;
            color: #fff;
            font-size: 16px;
            float: right;
            margin-left: 15px;
            cursor: pointer;
        }
    </style>
    <link rel="stylesheet" href="registrologin.css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
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
                    <a href="#">
                        <i class="fas fa-laptop"></i>
                        <span>TechStore</span>
                    </a>
                </div>
            </header>

            <!-- Formulario de Inicio de Sesión -->
            <div class="auth-wrapper">
                <div class="auth-card">
                    <div class="auth-card-header">
                        <h1>Bienvenido de vuelta</h1>
                        <p>Inicia sesión en tu cuenta para continuar</p>
                    </div>

                    <div class="auth-form">
                        <div class="form-group">
                            <label for="txtEmail">
                                <i class="fas fa-envelope"></i>
                                Correo electrónico
                            </label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="tu@email.com" />
                            <div class="input-focus-effect"></div>
                        </div>

                        <div class="form-group">
                            <label for="txtPassword">
                                <i class="fas fa-lock"></i>
                                Contraseña
                            </label>
                            <div class="password-input">
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Tu contraseña" />
                                <button type="button" class="password-toggle" onclick="togglePassword('txtPassword')">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <div class="input-focus-effect"></div>
                        </div>

                        <div class="form-options">
                            <label class="checkbox-container">
                                <input type="checkbox" />
                                <span class="checkmark"></span>
                                Recordarme
                            </label>
                            <a href="#" class="forgot-password">¿Olvidaste tu contraseña?</a>
                        </div>

                        <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión" CssClass="auth-button primary" OnClick="btnLogin_Click" />
                    </div>

                    <div class="divider">
                        <span>O continúa con</span>
                    </div>

                    <div class="social-login">
                        <button type="button" class="social-button google">
                            <i class="fab fa-google"></i>
                            <span>Google</span>
                        </button>
                        <button type="button" class="social-button facebook">
                            <i class="fab fa-facebook-f"></i>
                            <span>Facebook</span>
                        </button>
                        <button type="button" class="social-button github">
                            <i class="fab fa-github"></i>
                            <span>GitHub</span>
                        </button>
                    </div>

                    <div class="auth-footer">
                        <p>¿No tienes una cuenta? <a href="Registro.aspx">Regístrate aquí</a></p>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="Scripts/login.js"></script>

    <script>
        function togglePassword(id) {
            const input = document.getElementById(id);
            if (input.type === "password") {
                input.type = "text";
            } else {
                input.type = "password";
            }
        }

        window.onload = function () {
            const toast = document.getElementById('toastMessage');
            if (toast) {
                toast.classList.add('show');
                setTimeout(() => {
                    toast.classList.remove('show');
                }, 4000);
            }
        };
    </script>
</body>
</html>