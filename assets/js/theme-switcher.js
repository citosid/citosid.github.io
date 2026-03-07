(function() {
  const select = document.getElementById('theme-select');
  if (!select) return;

  try {
    const currentTheme = localStorage.getItem('theme') || '';
    select.value = currentTheme;
  } catch (e) {
    // localStorage unavailable
  }

  select.addEventListener('change', function() {
    const theme = this.value;
    
    if (theme) {
      document.documentElement.setAttribute('data-theme', theme);
      try {
        localStorage.setItem('theme', theme);
      } catch (e) {
        // localStorage unavailable
      }
    } else {
      document.documentElement.removeAttribute('data-theme');
      try {
        localStorage.removeItem('theme');
      } catch (e) {
        // localStorage unavailable
      }
    }
  });
})();
