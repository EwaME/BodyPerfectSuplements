<div class="bp-card-wrapper">
  <div class="bp-card">
    <div class="bp-card-img">
      {{if productImgUrl}}
      <img src="{{~BASE_DIR}}/public/imgs/products/{{productImgUrl}}" alt="{{productName}}" loading="lazy" />
      {{endif productImgUrl}}
      {{ifnot productImgUrl}}
      <div class="bp-card-img-placeholder">
        <i class="fas fa-dumbbell"></i>
      </div>
      {{endifnot productImgUrl}}

      {{if hasSale}}
      <span class="bp-badge-sale">Oferta</span>
      {{endif hasSale}}
      {{if isAgotado}}
      <span class="bp-badge-oos">Agotado</span>
      {{endif isAgotado}}

      {{ifnot isAgotado}}
      <div class="bp-card-overlay">
        <a href="index.php?page=Products_Detail&id={{productId}}" class="bp-overlay-btn">
          <i class="fas fa-eye"></i>&nbsp;Ver producto
        </a>
      </div>
      {{endifnot isAgotado}}
    </div>

    <div class="bp-card-body">
      {{if categoryName}}
      <div class="bp-card-cat">{{categoryName}}</div>
      {{endif categoryName}}
      <h3 class="bp-card-name">{{productName}}</h3>
      <p class="bp-card-desc">{{productDescription}}</p>

      <div class="bp-card-footer">
        <div class="bp-price-block">
          {{if hasSale}}
          <div class="bp-price-original">L. {{productPrice}}</div>
          <div class="bp-price-sale">L. {{salePrice}}</div>
          {{endif hasSale}}
          {{ifnot hasSale}}
          <div class="bp-price-regular">L. {{productPrice}}</div>
          {{endifnot hasSale}}
        </div>
        {{if isAgotado}}
        <span class="bp-status-ago"><i class="fas fa-times-circle"></i>&nbsp;Agotado</span>
        {{endif isAgotado}}
        {{ifnot isAgotado}}
        <a href="index.php?page=Products_Detail&id={{productId}}" class="bp-card-link">
          Ver&nbsp;<i class="fas fa-arrow-right"></i>
        </a>
        {{endifnot isAgotado}}
      </div>
    </div>
  </div>
</div>
