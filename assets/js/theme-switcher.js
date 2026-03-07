(function() {
  var select = document.getElementById('theme-select');
  if (!select) return;

  try {
    select.value = localStorage.getItem('theme') || 'rose-pine';
  } catch (e) {}

  select.addEventListener('change', function() {
    var theme = this.value;
    document.documentElement.setAttribute('data-theme', theme);
    try { localStorage.setItem('theme', theme); } catch (e) {}
  });
})();
