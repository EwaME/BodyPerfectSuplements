<div class="container-m py-5">

  <h2 class="bp-section-title" style="margin-bottom:1.25rem;"><i class="fas fa-store"></i>&nbsp;Catálogo de Productos</h2>

  <!-- Buscador principal -->
  <div class="bp-search-wrap">
    <i class="fas fa-search bp-search-icon-left"></i>
    <input type="text" id="bp-search-input" value="{{search}}"
           placeholder="Buscar suplementos, marcas, categorías..."
           class="bp-search-input" autocomplete="off" />
    <button type="button" id="bp-search-clear" class="bp-search-clear">
      <i class="fas fa-times"></i>
    </button>
    <div id="bp-search-dropdown" class="bp-search-dropdown"></div>
  </div>

  <form id="bp-filter-form" method="GET" action="index.php">
    <input type="hidden" name="page" value="Products_Products" />
    <input type="hidden" id="bp-filter-q" name="q" value="{{search}}" />

    <div class="bp-catalog-layout">

      <!-- Sidebar filtros -->
      <aside class="bp-filter-sidebar">
        <div class="bp-sidebar-header">
          <span>Filtros</span>
          <a href="index.php?page=Products_Products" class="bp-sidebar-clear">Limpiar todo</a>
        </div>

        <div class="bp-sidebar-section">
          <div class="bp-sidebar-title">Categorías</div>
          <label class="bp-sidebar-radio">
            <input type="radio" name="cat" value="" {{ifnot catId}}checked{{endifnot catId}} />
            <span>Todas</span>
          </label>
          {{foreach categorias}}
          <label class="bp-sidebar-radio">
            <input type="radio" name="cat" value="{{categoryId}}" {{if isActive}}checked{{endif isActive}} />
            <span>{{categoryName}}</span>
          </label>
          {{endfor categorias}}
        </div>

        <div class="bp-sidebar-section bp-price-section">
          <div class="bp-sidebar-title"><i class="fas fa-coins"></i>&nbsp;Rango de Precio</div>
          <div class="bp-price-inputs">
            <label class="bp-price-field">
              <span class="bp-price-currency">L.</span>
              <input type="number" id="bp-price-min" name="minPrice" min="0" step="1"
                     placeholder="0" value="{{minPrice}}" />
            </label>
            <span class="bp-price-sep"><i class="fas fa-arrow-right-long"></i></span>
            <label class="bp-price-field">
              <span class="bp-price-currency">L.</span>
              <input type="number" id="bp-price-max" name="maxPrice" min="0" step="1"
                     placeholder="{{maxPriceSlider}}" value="{{maxPrice}}" />
            </label>
          </div>
          <div class="bp-price-presets">
            <button type="button" class="bp-price-chip" data-min="" data-max="30">Menos de L.30</button>
            <button type="button" class="bp-price-chip" data-min="30" data-max="60">L.30 – L.60</button>
            <button type="button" class="bp-price-chip" data-min="60" data-max="">Más de L.60</button>
          </div>
        </div>
      </aside>

      <!-- Contenido principal -->
      <div class="bp-catalog-main">

        {{if productos}}
        <p class="bp-result-count">{{total}} producto(s) encontrado(s)</p>
        <div class="grid bp-product-grid">
          {{foreach productos}}
          {{include partials/product_card}}
          {{endfor productos}}
        </div>

        <div class="bp-pagination">
          {{if hasPrev}}
          <a href="index.php?page=Products_Products&p={{prevPage}}&q={{search}}&cat={{catId}}&minPrice={{minPrice}}&maxPrice={{maxPrice}}" class="bp-page-btn">
            <i class="fas fa-chevron-left"></i>
          </a>
          {{endif hasPrev}}
          <span class="bp-page-info">Página {{page}} de {{totalPages}}</span>
          {{if hasNext}}
          <a href="index.php?page=Products_Products&p={{nextPage}}&q={{search}}&cat={{catId}}&minPrice={{minPrice}}&maxPrice={{maxPrice}}" class="bp-page-btn">
            <i class="fas fa-chevron-right"></i>
          </a>
          {{endif hasNext}}
        </div>
        {{endif productos}}

        {{ifnot productos}}
        <div class="bp-empty">
          <i class="fas fa-box-open"></i>
          <p>No se encontraron productos con esos filtros.</p>
          <a href="index.php?page=Products_Products" class="bp-btn-cta">Ver todos</a>
        </div>
        {{endifnot productos}}

      </div>
    </div>
  </form>

</div>

<script>window.__BP_BASE = '{{~BASE_DIR}}';</script>
<script>
(function () {
  var form      = document.getElementById('bp-filter-form');
  var searchVis = document.getElementById('bp-search-input');
  var searchHid = document.getElementById('bp-filter-q');
  var clearBtn  = document.getElementById('bp-search-clear');
  var dropdown  = document.getElementById('bp-search-dropdown');
  var cats      = form.querySelectorAll('input[name="cat"]');
  var priceMin  = document.getElementById('bp-price-min');
  var priceMax  = document.getElementById('bp-price-max');
  var submitTimer, acTimer;

  /* helpers */
  function escHtml(s) {
    return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
  }
  function resetPage() {
    var p = form.querySelector('input[name="p"]');
    if (!p) { p = document.createElement('input'); p.type='hidden'; p.name='p'; form.appendChild(p); }
    p.value = 1;
  }
  function submitForm() {
    searchHid.value = searchVis.value;
    resetPage();
    form.submit();
  }
  function debounceSubmit() {
    clearTimeout(submitTimer);
    submitTimer = setTimeout(submitForm, 420);
  }

  /* precio */
  function normalizePrice() {
    var lo = priceMin.value !== '' ? parseFloat(priceMin.value) : null;
    var hi = priceMax.value !== '' ? parseFloat(priceMax.value) : null;
    if (lo !== null && hi !== null && lo > hi) {
      priceMin.value = hi;
      priceMax.value = lo;
    }
  }
  [priceMin, priceMax].forEach(function (el) {
    el.addEventListener('change', function () { normalizePrice(); submitForm(); });
    el.addEventListener('keydown', function (e) {
      if (e.key === 'Enter') { e.preventDefault(); normalizePrice(); submitForm(); }
    });
  });

  /* chips de precio rápido */
  form.querySelectorAll('.bp-price-chip').forEach(function (chip) {
    chip.addEventListener('click', function () {
      priceMin.value = chip.dataset.min || '';
      priceMax.value = chip.dataset.max || '';
      submitForm();
    });
  });

  /* clear button */
  function updateClear() { clearBtn.style.display = searchVis.value ? 'flex' : 'none'; }
  updateClear();
  clearBtn.addEventListener('click', function () {
    searchVis.value = ''; searchHid.value = '';
    updateClear(); hideDropdown(); submitForm();
  });

  /* search */
  searchVis.addEventListener('input', function () {
    updateClear(); debounceSubmit();
    clearTimeout(acTimer);
    acTimer = setTimeout(function () { fetchAutocomplete(searchVis.value); }, 280);
  });
  searchVis.addEventListener('keydown', function (e) {
    if (e.key === 'Enter')  { e.preventDefault(); hideDropdown(); submitForm(); }
    if (e.key === 'Escape') { hideDropdown(); }
  });
  searchVis.addEventListener('focus', function () {
    if (searchVis.value.length >= 2) fetchAutocomplete(searchVis.value);
  });

  /* categories */
  cats.forEach(function (r) { r.addEventListener('change', submitForm); });

  /* autocomplete */
  function fetchAutocomplete(q) {
    if (q.length < 2) { hideDropdown(); return; }
    fetch('index.php?page=Products_Autocomplete&q=' + encodeURIComponent(q))
      .then(function (r) { return r.json(); })
      .then(showDropdown)
      .catch(hideDropdown);
  }
  function showDropdown(items) {
    if (!items || !items.length) { hideDropdown(); return; }
    var base = window.__BP_BASE || '';
    dropdown.innerHTML = items.map(function (p) {
      var imgHtml = p.productImgUrl
        ? '<img src="' + base + '/public/imgs/products/' + escHtml(p.productImgUrl) + '" alt="" />'
        : '<div class="bp-ac-placeholder"><i class="fas fa-dumbbell"></i></div>';
      var priceHtml = p.hasSale == 1
        ? '<s style="color:#aaa;font-size:0.78rem;">L.&nbsp;' + parseFloat(p.productPrice).toFixed(2) + '</s> '
          + '<strong style="color:#e63946;">L.&nbsp;' + parseFloat(p.salePrice).toFixed(2) + '</strong>'
        : '<strong>L.&nbsp;' + parseFloat(p.productPrice).toFixed(2) + '</strong>';
      return '<a href="index.php?page=Products_Detail&id=' + p.productId + '" class="bp-ac-item">'
        + '<div class="bp-ac-img">' + imgHtml + '</div>'
        + '<div class="bp-ac-info"><div class="bp-ac-name">' + escHtml(p.productName) + '</div>'
        + '<div class="bp-ac-meta">'
        + (p.categoryName ? '<span class="bp-ac-cat">' + escHtml(p.categoryName) + '</span>' : '')
        + priceHtml + '</div></div></a>';
    }).join('') + '<div class="bp-ac-footer">Presiona Enter para ver todos los resultados</div>';
    dropdown.style.display = 'block';
  }
  function hideDropdown() { dropdown.style.display = 'none'; dropdown.innerHTML = ''; }
  document.addEventListener('click', function (e) {
    if (!dropdown.contains(e.target) && e.target !== searchVis) hideDropdown();
  });
})();
</script>
