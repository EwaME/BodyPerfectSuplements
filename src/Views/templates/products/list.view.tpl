<div class="container-m py-5">

  <div class="row align-center" style="margin-bottom:1.5rem;">
    <h2 style="margin:0;flex:1;">Gestión de Productos</h2>
    <a href="index.php?page=Products_Create" class="bp-btn-cta" style="font-size:0.9rem;padding:0.6rem 1.2rem;">
      <i class="fas fa-plus"></i>&nbsp;Nuevo Producto
    </a>
  </div>

  {{if ok}}
  <div class="bp-admin-alert bp-alert-ok">
    <i class="fas fa-check-circle"></i>&nbsp;Cambios guardados correctamente.
  </div>
  {{endif ok}}

  <!-- Barra de búsqueda y filtros -->
  <form method="GET" action="index.php" id="admin-filter-form" class="bp-admin-filter-bar">
    <input type="hidden" name="page" value="Products_Admin" />

    <div class="bp-admin-search-wrap">
      <i class="fas fa-search bp-admin-search-icon"></i>
      <input type="text" name="q" value="{{search}}"
             placeholder="Buscar por nombre o descripción..."
             class="bp-admin-search-input" autocomplete="off" />
      {{if search}}
      <a href="index.php?page=Products_Admin" class="bp-admin-search-clear" title="Limpiar">
        <i class="fas fa-times"></i>
      </a>
      {{endif search}}
    </div>

    <div class="bp-admin-status-tabs">
      <button type="submit" name="status" value=""
              class="bp-status-tab {{if isFilterAll}}active{{endif isFilterAll}}">
        Todos
      </button>
      <button type="submit" name="status" value="ACT"
              class="bp-status-tab act {{if isFilterACT}}active{{endif isFilterACT}}">
        <i class="fas fa-circle" style="font-size:0.55rem;"></i>&nbsp;Activos
      </button>
      <button type="submit" name="status" value="INA"
              class="bp-status-tab ina {{if isFilterINA}}active{{endif isFilterINA}}">
        <i class="fas fa-circle" style="font-size:0.55rem;"></i>&nbsp;Inactivos
      </button>
      <button type="submit" name="status" value="AGO"
              class="bp-status-tab ago {{if isFilterAGO}}active{{endif isFilterAGO}}">
        <i class="fas fa-circle" style="font-size:0.55rem;"></i>&nbsp;Agotados
      </button>
    </div>
  </form>

  <div class="bp-admin-result-info">
    <span>{{total}} producto(s) encontrado(s)</span>
  </div>

  <div class="WWList">
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Nombre</th>
          <th>Categoría</th>
          <th>Precio</th>
          <th>Stock</th>
          <th>Estado</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        {{foreach productos}}
        <tr>
          <td>{{productId}}</td>
          <td><strong>{{productName}}</strong></td>
          <td>{{categoryName}}</td>
          <td>L. {{productPrice}}</td>
          <td>{{productStock}}</td>
          <td>
            {{if isACT}}<span class="bp-status-badge bp-badge-act">Activo</span>{{endif isACT}}
            {{if isINA}}<span class="bp-status-badge bp-badge-ina">Inactivo</span>{{endif isINA}}
            {{if isAGO}}<span class="bp-status-badge bp-badge-ago">Agotado</span>{{endif isAGO}}
          </td>
          <td class="bp-admin-actions">
            <a href="index.php?page=Products_Edit&id={{productId}}" class="bp-btn-admin bp-btn-edit" title="Editar">
              <i class="fas fa-pencil-alt"></i>
            </a>
            {{if isACT}}
            <a href="index.php?page=Products_Toggle&id={{productId}}&status=INA"
               class="bp-btn-admin bp-btn-toggle-off" title="Desactivar"
               onclick="return confirm('¿Desactivar este producto?')">
              <i class="fas fa-toggle-on"></i>
            </a>
            {{endif isACT}}
            {{if isINA}}
            <a href="index.php?page=Products_Toggle&id={{productId}}&status=ACT"
               class="bp-btn-admin bp-btn-toggle-on" title="Activar"
               onclick="return confirm('¿Activar este producto?')">
              <i class="fas fa-toggle-off"></i>
            </a>
            {{endif isINA}}
          </td>
        </tr>
        {{endfor productos}}
      </tbody>
    </table>
  </div>

  <!-- Paginación -->
  <div class="bp-pagination" style="margin-top:1.25rem;">
    {{if hasPrev}}
    <a href="index.php?page=Products_Admin&p={{prevPage}}&q={{search}}&status={{filterStatus}}" class="bp-page-btn">
      <i class="fas fa-chevron-left"></i>
    </a>
    {{endif hasPrev}}
    <span class="bp-page-info">Página {{page}} de {{totalPages}}</span>
    {{if hasNext}}
    <a href="index.php?page=Products_Admin&p={{nextPage}}&q={{search}}&status={{filterStatus}}" class="bp-page-btn">
      <i class="fas fa-chevron-right"></i>
    </a>
    {{endif hasNext}}
  </div>

</div>

<style>
.bp-admin-filter-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  align-items: center;
  margin-bottom: 1rem;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  padding: 0.75rem 1rem;
}
.bp-admin-search-wrap {
  position: relative;
  flex: 1;
  min-width: 200px;
}
.bp-admin-search-icon {
  position: absolute;
  left: 0.85rem;
  top: 50%;
  transform: translateY(-50%);
  color: #aaa;
  font-size: 0.85rem;
  pointer-events: none;
}
.bp-admin-search-input {
  width: 100%;
  padding: 0.55rem 2.2rem 0.55rem 2.4rem;
  border: 1.5px solid #e0e0e0;
  border-radius: 8px;
  font-size: 0.88rem;
  outline: none;
  background: #f9fafb;
  color: #1a1a2e;
  box-sizing: border-box;
  transition: border-color 0.15s, box-shadow 0.15s;
  margin: 0;
}
.bp-admin-search-input:focus {
  border-color: var(--bp-accent);
  box-shadow: 0 0 0 3px rgba(0,196,154,0.12);
  background: #fff;
}
.bp-admin-search-clear {
  position: absolute;
  right: 0.6rem;
  top: 50%;
  transform: translateY(-50%);
  color: #bbb;
  font-size: 0.8rem;
  text-decoration: none;
  transition: color 0.15s;
  line-height: 1;
}
.bp-admin-search-clear:hover { color: #e63946; }
.bp-admin-status-tabs {
  display: flex;
  gap: 0.35rem;
  flex-wrap: wrap;
}
.bp-status-tab {
  font-family: inherit;
  font-size: 0.8rem;
  font-weight: 600;
  padding: 0.45rem 0.9rem;
  border-radius: 999px;
  border: 1.5px solid #e0e0e0;
  background: #fff;
  color: #666;
  cursor: pointer;
  transition: all 0.15s ease;
  margin: 0;
}
.bp-status-tab:hover { border-color: #999; color: #333; }
.bp-status-tab.active { background: #1a1a2e; border-color: #1a1a2e; color: #fff; }
.bp-status-tab.act.active { background: #155724; border-color: #155724; }
.bp-status-tab.ina.active { background: #721c24; border-color: #721c24; }
.bp-status-tab.ago.active { background: #555; border-color: #555; }
.bp-admin-result-info {
  font-size: 0.82rem;
  color: #888;
  margin-bottom: 0.75rem;
}
</style>

<script>
(function(){
  var inp = document.querySelector('.bp-admin-search-input');
  var form = document.getElementById('admin-filter-form');
  var t;
  if (inp) {
    inp.addEventListener('input', function(){
      clearTimeout(t);
      t = setTimeout(function(){ form.submit(); }, 450);
    });
    inp.addEventListener('keydown', function(e){
      if (e.key === 'Enter') { e.preventDefault(); clearTimeout(t); form.submit(); }
    });
  }
})();
</script>
