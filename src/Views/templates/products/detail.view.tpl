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

<!-- ===== RESEÑAS ===== -->
<div class="container-m" style="padding:0 1rem 3rem;">
  <div class="bp-reviews-section">

    <h2 class="bp-reviews-title">
      <i class="fas fa-star"></i>&nbsp;Reseñas
      {{if hayReviews}}
      <span class="bp-reviews-avg">{{promedio}} / 5 &nbsp;({{totalReviews}} reseñas)</span>
      {{endif hayReviews}}
    </h2>

    <!-- Formulario: solo si compró y no ha reseñado -->
    {{if puedeResenar}}
    <form class="bp-review-form" method="post" action="index.php?page=Reviews_Review">
      <input type="hidden" name="productId" value="{{productId}}" />
      <div class="bp-review-stars" id="starPicker">
        <input type="radio" name="calificacion" id="s5" value="5"><label for="s5" title="5">★</label>
        <input type="radio" name="calificacion" id="s4" value="4"><label for="s4" title="4">★</label>
        <input type="radio" name="calificacion" id="s3" value="3"><label for="s3" title="3">★</label>
        <input type="radio" name="calificacion" id="s2" value="2"><label for="s2" title="2">★</label>
        <input type="radio" name="calificacion" id="s1" value="1"><label for="s1" title="1">★</label>
      </div>
      <textarea name="comentario" class="bp-review-textarea" placeholder="Escribe tu experiencia con este producto (opcional)" maxlength="500"></textarea>
      <button type="submit" class="bp-btn-cta" style="width:auto;padding:.6rem 1.5rem;">
        <i class="fas fa-paper-plane"></i>&nbsp;Publicar reseña
      </button>
    </form>
    {{endif puedeResenar}}

    {{if isMsgYaRevisado}}
    <p class="bp-review-notice"><i class="fas fa-check-circle"></i>&nbsp;Ya dejaste tu reseña para este producto.</p>
    {{endif isMsgYaRevisado}}

    {{if isMsgNoCompro}}
    <p class="bp-review-notice" style="color:#9ca3af;"><i class="fas fa-lock"></i>&nbsp;Solo usuarios que compraron este producto pueden dejar reseña.</p>
    {{endif isMsgNoCompro}}

    {{ifnot isLogged}}
    <p class="bp-review-notice" style="color:#9ca3af;">
      <a href="index.php?page=Sec_Login">Inicia sesión</a> para dejar una reseña.
    </p>
    {{endifnot isLogged}}

    <!-- Lista de reseñas -->
    {{if hayReviews}}
    <div class="bp-review-list">
      {{foreach reviews}}
      <div class="bp-review-item">
        <div class="bp-review-header">
          <span class="bp-review-user"><i class="fas fa-user-circle"></i>&nbsp;{{username}}</span>
          <span class="bp-review-stars-display">{{estrellas}}</span>
          <span class="bp-review-date">{{created_at}}</span>
        </div>
        {{if comentario}}
        <p class="bp-review-body">{{comentario}}</p>
        {{endif comentario}}
      </div>
      {{endfor reviews}}
    </div>
    {{endif hayReviews}}

    {{ifnot hayReviews}}
    <p class="bp-review-notice" style="color:#9ca3af; margin-top:1rem;">
      <i class="fas fa-comment-slash"></i>&nbsp;Este producto aún no tiene reseñas.
    </p>
    {{endifnot hayReviews}}

  </div>
</div>

<style>
.bp-reviews-section { background:#fff; border-radius:12px; padding:2rem; box-shadow:0 2px 8px rgba(0,0,0,.08); }
.bp-reviews-title { font-size:1.3rem; margin-bottom:1.5rem; display:flex; align-items:center; gap:.75rem; flex-wrap:wrap; }
.bp-reviews-avg { font-size:1rem; color:#f59e0b; font-weight:600; }
.bp-review-form { display:flex; flex-direction:column; gap:.75rem; margin-bottom:2rem; padding:1.25rem; background:#f8fafc; border-radius:8px; }
.bp-review-stars { display:flex; flex-direction:row-reverse; justify-content:flex-end; gap:.25rem; }
.bp-review-stars input { display:none; }
.bp-review-stars label { font-size:2rem; color:#d1d5db; cursor:pointer; }
.bp-review-stars input:checked ~ label,
.bp-review-stars label:hover,
.bp-review-stars label:hover ~ label { color:#f59e0b; }
.bp-review-textarea { width:100%; min-height:80px; padding:.75rem; border:1px solid #e5e7eb; border-radius:8px; font-family:inherit; font-size:.9rem; resize:vertical; }
.bp-review-notice { padding:.75rem 1rem; background:#f1f5f9; border-radius:8px; margin-bottom:1rem; }
.bp-review-list { display:flex; flex-direction:column; gap:1rem; margin-top:1rem; }
.bp-review-item { padding:1rem; border:1px solid #f1f5f9; border-radius:8px; }
.bp-review-header { display:flex; align-items:center; gap:.75rem; flex-wrap:wrap; margin-bottom:.4rem; }
.bp-review-user { font-weight:600; font-size:.9rem; }
.bp-review-stars-display { color:#f59e0b; letter-spacing:2px; }
.bp-review-date { color:#9ca3af; font-size:.8rem; margin-left:auto; }
.bp-review-body { color:#374151; font-size:.9rem; margin:0; }
</style>
