<div class="container-m py-5">

  <div class="row align-center" style="margin-bottom:1.5rem;">
    <h2 style="margin:0;flex:1;">Gestión de Productos</h2>
    <a href="index.php?page=Products_Create" class="bp-btn-cta" style="font-size:0.9rem;padding:0.6rem 1.2rem;">
      <i class="fas fa-plus"></i>&nbsp;Nuevo Producto
    </a>
  </div>

  {{if ok}}
  <div class="bp-admin-alert bp-alert-ok">
    {{if ok}}Cambios guardados correctamente.{{endif ok}}
  </div>
  {{endif ok}}

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

</div>
