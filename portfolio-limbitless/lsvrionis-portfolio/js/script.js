document.addEventListener("DOMContentLoaded", function() {
    setTimeout(function() {
        document.querySelector('.typing-text').style.animation = 'typing 2s steps(10, end) forwards';
    }, 1000); // 1 second delay
});

function toggleMenu() {
    const navbarRight = document.querySelector('.navbar-right');
    navbarRight.classList.toggle('active');
}
<script src="https://kit.fontawesome.com/efb49abce0.js" crossorigin="anonymous"></script>