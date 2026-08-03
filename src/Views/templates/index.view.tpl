<div class="herocontainer">
  <div class="hero">
    <img src="{{BASE_DIR}}/public/imgs/hero/suplementosEj.png" alt="BodyPerfect Suplementos" />
    <div class="bp-hero-overlay"></div>
    <div class="bp-hero-content">
      <h2>Tu destino en suplementos deportivos</h2>
      <p>Calidad premium para alcanzar tus metas en el gym</p>
      <a href="index.php?page=Products_Products" class="bp-btn-cta">
        <i class="fas fa-store"></i>&nbsp;Ver Catálogo
      </a>
    </div>
  </div>
</div>

{{if destacados}}
<section class="bp-section">
  <div class="container-m">
    <h2 class="bp-section-title"><i class="fas fa-star"></i>&nbsp;Productos Destacados</h2>
    <div class="grid bp-product-grid">
      {{foreach destacados}}
      {{include partials/product_card}}
      {{endfor destacados}}
    </div>
    <div class="bp-section-more">
      <a href="index.php?page=Products_Products" class="bp-btn-outline">Ver todos los productos</a>
    </div>
  </div>
</section>
{{endif destacados}}

{{if ofertas}}
<section class="bp-section bp-section-ofertas">
  <div class="container-m">
    <h2 class="bp-section-title"><i class="fas fa-tag"></i>&nbsp;Ofertas del Día</h2>
    <div class="grid bp-product-grid">
      {{foreach ofertas}}
      {{include partials/product_card}}
      {{endfor ofertas}}
    </div>
  </div>
</section>
{{endif ofertas}}

{{ifnot destacados}}
{{ifnot ofertas}}
<section class="bp-section">
  <div class="container-m bp-empty">
    <i class="fas fa-store-slash"></i>
    <p>Próximamente encontrarás aquí nuestro catálogo de suplementos.</p>
    <a href="index.php?page=Sec_Register" class="bp-btn-cta">Crear cuenta</a>
  </div>
</section>
{{endifnot ofertas}}
{{endifnot destacados}}
