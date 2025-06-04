
document.addEventListener("DOMContentLoaded", function() {
    setTimeout(function() {
        document.querySelector('.typing-text').style.animation = 'typing 2s steps(10, end) forwards';
    }, 1000); // 1 second delay
});

const skillItems = document.querySelectorAll('.skill-item');

skillItems.forEach((skillItem) => {
  skillItem.addEventListener('click', () => {
    console.log(`Activated skill item: ${skillItem.getAttribute('title')}`);
  });
});

skillItems.forEach((skillItem) => {
    skillItem.addEventListener('click', (event) => {
      if (event.type === 'click' || event.type === 'touchstart') {
        console.log(`Activated skill item: ${skillItem.getAttribute('title')}`);
      }
    });
  });

  const hamburgerMenu = document.querySelector('.hamburger-menu');

hamburgerMenu.addEventListener('keydown', (event) => {
  if (event.key === 'Enter' || event.key === ' ') {
    // toggle the hamburger menu
  }
});