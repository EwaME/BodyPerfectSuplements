<div class="container-m py-5" style="max-width:680px;">

  <div class="row align-center" style="margin-bottom:1.5rem;">
    <h2 style="margin:0;flex:1;">{{formTitle}}</h2>
    <a href="index.php?page=Products_Products" style="color:#666;font-size:0.9rem;">
      <i class="fas fa-arrow-left"></i>&nbsp;Volver
    </a>
  </div>

  <form method="POST" action="{{formAction}}" enctype="multipart/form-data">

    <div class="bp-form-group">
      <label for="productName">Nombre del producto</label>
      <input type="text" id="productName" name="productName" class="width-full" value="{{productName}}" />
      {{if errorName}}<span class="error">{{errorName}}</span>{{endif errorName}}
    </div>

    <div class="bp-form-group">
      <label for="productDescription">Descripción</label>
      <textarea id="productDescription" name="productDescription" class="width-full" rows="3">{{productDescription}}</textarea>
    </div>

    <div class="row" style="gap:1rem;">
      <div class="bp-form-group col-m-6" style="flex:1;">
        <label for="productPrice">Precio (L.)</label>
        <input type="number" id="productPrice" name="productPrice" class="width-full" step="0.01" min="0.01" value="{{productPrice}}" />
        {{if errorPrice}}<span class="error">{{errorPrice}}</span>{{endif errorPrice}}
      </div>
      <div class="bp-form-group col-m-6" style="flex:1;">
        <label for="productStock">Stock</label>
        <input type="number" id="productStock" name="productStock" class="width-full" min="0" value="{{productStock}}" />
      </div>
    </div>

    <div class="bp-form-group">
      <label for="categoryId">Categoría</label>
      <select id="categoryId" name="categoryId" class="width-full">
        <option value="">-- Sin categoría --</option>
        {{foreach categorias}}
        <option value="{{categoryId}}" {{if isSelected}}selected{{endif isSelected}}>{{categoryName}}</option>
        {{endfor categorias}}
      </select>
    </div>

    <div class="bp-form-group">
      <label>Imagen del producto</label>
      {{if isEdit}}
      <input type="hidden" name="productImgUrlActual" value="{{productImgUrl}}" />
      {{endif isEdit}}
      <div id="bp-img-preview-wrap" style="margin-bottom:0.75rem;{{if productImgUrl}}display:block;{{endif productImgUrl}}{{ifnot productImgUrl}}display:none;{{endifnot productImgUrl}}">
        <img id="bp-img-preview"
             src="{{if productImgUrl}}{{~BASE_DIR}}/public/imgs/products/{{productImgUrl}}{{endif productImgUrl}}"
             alt="Vista previa"
             style="max-height:140px;border-radius:6px;border:1px solid #ddd;display:block;" />
        <p id="bp-img-preview-name" style="font-size:0.78rem;color:#888;margin:0.3rem 0 0;">{{productImgUrl}}</p>
      </div>
      <input type="file" id="productImg" name="productImg" accept="image/*" style="width:100%;margin-top:0.3rem;" />
      <small style="color:#666;">JPG, PNG, WEBP — máx. 5 MB. Deja vacío para conservar la imagen actual.</small>
      {{if errorImg}}<span class="error">{{errorImg}}</span>{{endif errorImg}}
    </div>

    <div class="bp-form-group">
      <label>Estado</label>
      <div class="row" style="gap:1.5rem;margin-top:0.5rem;">
        <label style="font-weight:normal;display:flex;align-items:center;gap:0.4rem;">
          <input type="radio" name="productStatus" value="ACT" {{if isACT}}checked{{endif isACT}} />
          Activo
        </label>
        <label style="font-weight:normal;display:flex;align-items:center;gap:0.4rem;">
          <input type="radio" name="productStatus" value="INA" {{ifnot isACT}}checked{{endifnot isACT}} />
          Inactivo
        </label>
      </div>
    </div>

    <div style="margin-top:2rem;display:flex;gap:1rem;">
      <button type="submit" class="primary">
        <i class="fas fa-save"></i>&nbsp;Guardar
      </button>
      <a href="index.php?page=Products_Products" class="bp-btn-outline" style="padding:0.75rem 1.5rem;">
        Cancelar
      </a>
    </div>

  </form>
</div>

<script>
document.getElementById('productImg').addEventListener('change', function () {
  var file = this.files[0];
  var wrap = document.getElementById('bp-img-preview-wrap');
  var img  = document.getElementById('bp-img-preview');
  var name = document.getElementById('bp-img-preview-name');
  if (!file) return;
  img.src = URL.createObjectURL(file);
  img.onload = function () { URL.revokeObjectURL(img.src); };
  name.textContent = file.name;
  wrap.style.display = 'block';
});
</script>
