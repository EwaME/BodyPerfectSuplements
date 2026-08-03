<div class="container-m py-5">

  <nav class="bp-breadcrumb">
    <a href="index.php">Inicio</a>
    <span>/</span>
    <a href="index.php?page=Products_Products">Catálogo</a>
    <span>/</span>
    <span>Carrito</span>
  </nav>

  <h2 class="bp-section-title" style="margin-bottom:1.25rem;">
    <i class="fas fa-shopping-cart"></i>&nbsp;Mi Carrito
  </h2>

  {{ifnot items}}
  <div class="bp-cart-empty">
    <div class="bp-cart-empty-icon"><i class="fas fa-shopping-cart"></i></div>
    <h3>Tu carrito está vacío</h3>
    <p>Explora el catálogo y encuentra tu próximo suplemento.</p>
    <a href="index.php?page=Products_Products" class="bp-btn-cta">
      <i class="fas fa-store"></i>&nbsp;Ir al catálogo
    </a>
  </div>
  {{endifnot items}}

  {{if items}}
  <div class="bp-cart-layout">

    <div class="bp-cart-items">
      {{foreach items}}
      <div class="bp-cart-card{{if agotado}} bp-cart-card-warn{{endif agotado}}">

        <div class="bp-cart-card-top">
          <div class="bp-cart-item-img">
            {{if productImgUrl}}
            <img src="{{~BASE_DIR}}/public/imgs/products/{{productImgUrl}}" alt="{{productName}}" />
            {{endif productImgUrl}}
            {{ifnot productImgUrl}}
            <div class="bp-detail-img-placeholder"><i class="fas fa-dumbbell"></i></div>
            {{endifnot productImgUrl}}
          </div>

          <div class="bp-cart-item-info">
            <a href="index.php?page=Products_Detail&id={{productId}}" class="bp-cart-item-name">{{productName}}</a>
            <div class="bp-cart-item-price">Precio unitario: <strong>L. {{crrprc}}</strong></div>
            {{if agotado}}
            <div class="bp-cart-item-flag"><i class="fas fa-exclamation-triangle"></i>&nbsp;Ya no está disponible</div>
            {{endif agotado}}
            {{if inventarioLimitado}}
            <div class="bp-cart-item-flag bp-cart-item-flag-warn"><i class="fas fa-triangle-exclamation"></i>&nbsp;Inventario limitado: quedan {{productStock}} unidad(es)</div>
            {{endif inventarioLimitado}}
            {{if precioCambio}}
            <div class="bp-cart-item-flag bp-cart-item-flag-info"><i class="fas fa-circle-info"></i>&nbsp;El precio cambió a L. {{precioActual}} desde que lo agregaste</div>
            {{endif precioCambio}}
          </div>

          <div class="bp-cart-item-total">
            <span class="bp-cart-item-total-label">Subtotal línea</span>
            L. {{lineaTotal}}
          </div>
        </div>

        <div class="bp-cart-card-bottom">
          <form method="POST" action="index.php?page=Checkout_Cart&action=update&id={{productId}}" class="bp-qty-stepper">
            <span class="bp-qty-label">Cantidad</span>
            <input type="number" name="cantidad" value="{{crrctd}}" min="1" max="{{productStock}}" />
            <button type="submit" title="Actualizar cantidad">
              <i class="fas fa-rotate-right"></i>&nbsp;Actualizar
            </button>
          </form>

          <div class="bp-cart-item-actions">
            <a href="index.php?page=Checkout_Cart&action=save&id={{productId}}" class="bp-pill-btn">
              <i class="fas fa-clock"></i>&nbsp;Guardar
            </a>
            <a href="index.php?page=Checkout_Cart&action=remove&id={{productId}}" class="bp-pill-btn bp-pill-btn-danger" title="Eliminar">
              <i class="fas fa-trash"></i>
            </a>
          </div>
        </div>

      </div>
      {{endfor items}}
    </div>

    <div class="bp-cart-summary">
      <div class="bp-cart-summary-title"><i class="fas fa-receipt"></i>&nbsp;Resumen de compra</div>

      <div class="bp-cart-summary-row">
        <span><i class="fas fa-boxes-stacked"></i>&nbsp;Subtotal:</span>
        <span>L. {{subtotal}}</span>
      </div>
      <div class="bp-cart-summary-row">
        <span><i class="fas fa-file-invoice-dollar"></i>&nbsp;ISV (15%):</span>
        <span>L. {{isv}}</span>
      </div>
      <div class="bp-cart-summary-row">
        <span><i class="fas fa-truck"></i>&nbsp;Envío:</span>
        <span>L. {{envio}}</span>
      </div>
      <div class="bp-cart-summary-row bp-cart-summary-total">
        <span>Total:</span>
        <span>L. {{total}}</span>
      </div>

      <a href="index.php?page=Checkout_Cart&action=checkout" class="bp-cart-checkout-btn">
        <i class="fas fa-lock"></i>&nbsp;Proceder al pago
      </a>
      <a href="index.php?page=Products_Products" class="bp-cart-continue-link">
        <i class="fas fa-arrow-left"></i>&nbsp;Seguir comprando
      </a>
      <div class="bp-cart-summary-note"><i class="fas fa-shield-halved"></i>&nbsp;Pago seguro vía PayPal</div>
    </div>

  </div>
  {{endif items}}

  {{if guardados}}
  <div class="bp-cart-saved">
    <div class="bp-cart-saved-title">
      <i class="fas fa-clock"></i>&nbsp;Guardado para más tarde
    </div>
    <div class="bp-cart-saved-list">
      {{foreach guardados}}
      <div class="bp-cart-saved-item">
        <div class="bp-cart-saved-img">
          {{if productImgUrl}}
          <img src="{{~BASE_DIR}}/public/imgs/products/{{productImgUrl}}" alt="{{productName}}" />
          {{endif productImgUrl}}
          {{ifnot productImgUrl}}
          <div class="bp-detail-img-placeholder"><i class="fas fa-dumbbell"></i></div>
          {{endifnot productImgUrl}}
        </div>
        <div class="bp-cart-saved-name">{{productName}}</div>
        <div class="bp-cart-saved-price">L. {{productPrice}}</div>
        <div class="bp-cart-saved-actions">
          <a href="index.php?page=Checkout_Cart&action=unsave&id={{productId}}" class="bp-pill-btn">
            <i class="fas fa-cart-plus"></i>&nbsp;Mover al carrito
          </a>
          <a href="index.php?page=Checkout_Cart&action=discard&id={{productId}}" class="bp-pill-btn bp-pill-btn-danger" title="Quitar">
            <i class="fas fa-trash"></i>
          </a>
        </div>
      </div>
      {{endfor guardados}}
    </div>
  </div>
  {{endif guardados}}

</div>
