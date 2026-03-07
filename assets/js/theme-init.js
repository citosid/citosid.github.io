(function() {
  try {
    var theme = localStorage.getItem('theme') || 'rose-pine';
    document.documentElement.setAttribute('data-theme', theme);
  } catch (e) {
    document.documentElement.setAttribute('data-theme', 'rose-pine');
  }
})();
