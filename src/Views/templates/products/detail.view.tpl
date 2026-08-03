<div class="container-m py-5">

  <!-- Breadcrumb -->
  <nav class="bp-breadcrumb">
    <a href="index.php">Inicio</a>
    <span>/</span>
    <a href="index.php?page=Products_Products">Catálogo</a>
    <span>/</span>
    <span>{{productName}}</span>
  </nav>

  <div class="bp-detail-grid">

    <!-- Imagen -->
    <div class="bp-detail-img-wrap">
      {{if productImgUrl}}
      <img src="{{~BASE_DIR}}/public/imgs/products/{{productImgUrl}}"
           alt="{{productName}}"
           class="bp-detail-img" />
      {{endif productImgUrl}}
      {{ifnot productImgUrl}}
      <div class="bp-detail-img-placeholder">
        <i class="fas fa-dumbbell"></i>
      </div>
      {{endifnot productImgUrl}}
    </div>

    <!-- Info -->
    <div class="bp-detail-info">

      {{if categoryName}}
      <div class="bp-detail-cat">{{categoryName}}</div>
      {{endif categoryName}}

      <h1 class="bp-detail-name">{{productName}}</h1>

      <!-- Precio -->
      <div class="bp-detail-price-block">
        {{if hasSale}}
        <span class="bp-detail-price-original">L. {{productPrice}}</span>
        <span class="bp-detail-price-sale">L. {{salePrice}}</span>
        <span class="bp-badge-sale" style="position:static;display:inline-block;margin-left:0.5rem;">Oferta</span>
        {{endif hasSale}}
        {{ifnot hasSale}}
        <span class="bp-detail-price-regular">L. {{productPrice}}</span>
        {{endifnot hasSale}}
      </div>

      <!-- Stock / estado -->
      <div class="bp-detail-stock">
        {{if isAgotado}}
        <span class="bp-detail-oos"><i class="fas fa-times-circle"></i> Agotado</span>
        {{endif isAgotado}}
        {{ifnot isAgotado}}
        <span class="bp-detail-avail"><i class="fas fa-check-circle"></i> Disponible ({{productStock}} en stock)</span>
        {{endifnot isAgotado}}
      </div>

      <!-- Descripción -->
      {{if productDescription}}
      <p class="bp-detail-desc">{{productDescription}}</p>
      {{endif productDescription}}

      <!-- Acciones -->
      <div class="bp-detail-actions">
        {{ifnot isAgotado}}
        <a href="index.php?page=Checkout_Cart&action=add&id={{productId}}" class="bp-btn-cta bp-detail-btn-cart">
          <i class="fas fa-shopping-cart"></i>&nbsp;Agregar al carrito
        </a>
        {{endifnot isAgotado}}
        {{if isAgotado}}
        <button class="bp-btn-cta bp-detail-btn-cart" disabled style="opacity:0.5;cursor:not-allowed;">
          <i class="fas fa-times-circle"></i>&nbsp;Agotado
        </button>
        {{endif isAgotado}}
        <a href="index.php?page=Products_Products" class="bp-btn-outline" style="padding:0.85rem 1.5rem;">
          <i class="fas fa-arrow-left"></i>&nbsp;Volver al catálogo
        </a>
      </div>

    </div>
  </div>

</div>
