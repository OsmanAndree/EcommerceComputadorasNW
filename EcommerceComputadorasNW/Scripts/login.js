// Setup Animations
function setupAnimations() {
  // Animate form elements on load
  const formElements = document.querySelectorAll(".form-group, .social-button, .auth-button")
  formElements.forEach((element, index) => {
    element.style.opacity = "0"
    element.style.transform = "translateY(20px)"
    element.style.animation = `slideInUp 0.6s ease-out ${index * 0.1}s forwards`
  })

  // Add floating animation to background shapes
  const shapes = document.querySelectorAll(".shape")
  shapes.forEach((shape, index) => {
    shape.style.animationDelay = `${index * 2}s`
  })
}

// Add sparkle effect to buttons
document.addEventListener("DOMContentLoaded", () => {
  const buttons = document.querySelectorAll(".auth-button, .social-button")

  buttons.forEach((button) => {
    button.addEventListener("mouseenter", function () {
      createSparkles(this)
    })
  })
})

function createSparkles(element) {
  for (let i = 0; i < 4; i++) {
    const sparkle = document.createElement("div")
    sparkle.style.cssText = `
            position: absolute;
            width: 3px;
            height: 3px;
            background: white;
            border-radius: 50%;
            pointer-events: none;
            animation: sparkle 0.6s ease-out forwards;
            top: ${Math.random() * 100}%;
            left: ${Math.random() * 100}%;
            z-index: 1000;
        `

    element.style.position = "relative"
    element.appendChild(sparkle)

    setTimeout(() => {
      if (sparkle.parentNode) {
        sparkle.parentNode.removeChild(sparkle)
      }
    }, 600)
  }
}
