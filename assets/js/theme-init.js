(function() {
  try {
    const theme = localStorage.getItem('theme');
    if (theme) {
      document.documentElement.setAttribute('data-theme', theme);
    }
  } catch (e) {
    // localStorage unavailable, use default theme
  }
})();
