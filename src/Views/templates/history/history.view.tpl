<div class="container-m py-5">

  <div class="row align-center" style="margin-bottom:1.5rem;">
    <h2 style="margin:0;flex:1;"><i class="fas fa-history"></i>&nbsp;Histórico de Transacciones</h2>
    {{if hasPedidos}}
    <a href="index.php?page=History_Export&type=history&estado={{estado}}" class="bp-btn-cta" style="font-size:0.9rem;padding:0.6rem 1.2rem;">
      <i class="fas fa-file-csv"></i>&nbsp;Exportar CSV
    </a>
    {{endif hasPedidos}}
  </div>

  <p style="color:#666;margin-top:-1rem;margin-bottom:1.25rem;">Revisa tus compras realizadas y el estado de cada pedido.</p>

  <form method="GET" action="index.php" class="bp-admin-filter-bar">
    <input type="hidden" name="page" value="History_History" />
    <div class="bp-admin-status-tabs">
      <button type="submit" name="estado" value="ALL" class="bp-status-tab {{if isFilterAll}}active{{endif isFilterAll}}">Todos</button>
      <button type="submit" name="estado" value="APR" class="bp-status-tab act {{if isFilterAPR}}active{{endif isFilterAPR}}">
        <i class="fas fa-circle" style="font-size:0.55rem;"></i>&nbsp;Aprobados
      </button>
      <button type="submit" name="estado" value="PND" class="bp-status-tab pnd {{if isFilterPND}}active{{endif isFilterPND}}">
        <i class="fas fa-circle" style="font-size:0.55rem;"></i>&nbsp;Pendientes
      </button>
      <button type="submit" name="estado" value="RCH" class="bp-status-tab ina {{if isFilterRCH}}active{{endif isFilterRCH}}">
        <i class="fas fa-circle" style="font-size:0.55rem;"></i>&nbsp;Rechazados
      </button>
    </div>
  </form>

  {{if hasPedidos}}
  <div class="bp-admin-result-info">
    <span>{{total}} pedido(s) encontrado(s)</span>
  </div>

  <div class="WWList">
    <table>
      <thead>
        <tr>
          <th># Orden</th>
          <th>Fecha</th>
          <th>Método</th>
          <th>Total de Ítems</th>
          <th>Monto Total</th>
          <th>Estado</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        {{foreach pedidos}}
        <tr>
          <td><strong>#{{id}}</strong></td>
          <td>{{fecha}}</td>
          <td><i class="fab fa-paypal"></i>&nbsp;{{metodoPago}}</td>
          <td>{{totalItems}} producto(s)</td>
          <td><strong>L. {{total}}</strong></td>
          <td>
            {{if isAPR}}<span class="bp-status-badge bp-badge-act">Aprobado</span>{{endif isAPR}}
            {{if isPND}}<span class="bp-status-badge bp-badge-pnd">Pendiente</span>{{endif isPND}}
            {{if isRCH}}<span class="bp-status-badge bp-badge-ina">Rechazado</span>{{endif isRCH}}
            {{if isCAN}}<span class="bp-status-badge bp-badge-ago">Cancelado</span>{{endif isCAN}}
          </td>
          <td class="bp-admin-actions">
            <a href="index.php?page=History_Detail&id={{id}}" class="bp-btn-admin bp-btn-edit" title="Ver detalle">
              <i class="fas fa-eye"></i>
            </a>
          </td>
        </tr>
        {{endfor pedidos}}
      </tbody>
    </table>
  </div>

  {{if totalPages}}
  <div class="bp-pagination" style="margin-top:1.25rem;">
    {{if hasPrev}}
    <a href="index.php?page=History_History&p={{prevPage}}&estado={{estado}}" class="bp-page-btn">
      <i class="fas fa-chevron-left"></i>
    </a>
    {{endif hasPrev}}
    <span class="bp-page-info">Página {{page}} de {{totalPages}}</span>
    {{if hasNext}}
    <a href="index.php?page=History_History&p={{nextPage}}&estado={{estado}}" class="bp-page-btn">
      <i class="fas fa-chevron-right"></i>
    </a>
    {{endif hasNext}}
  </div>
  {{endif totalPages}}

  {{endif hasPedidos}}

  {{ifnot hasPedidos}}
  <div class="bp-empty">
    <i class="fas fa-shopping-bag"></i>
    <p>Aún no tienes compras registradas. Cuando realices pedidos en la tienda, aparecerán listados aquí para que puedas darles seguimiento.</p>
    <a href="index.php?page=Products_Products" class="bp-btn-cta">
      <i class="fas fa-store"></i>&nbsp;Ir al Catálogo de Productos
    </a>
  </div>
  {{endifnot hasPedidos}}

</div>

<style>
.bp-badge-pnd { background: #fff3cd; color: #856404; }
.bp-status-tab.pnd.active { background: #856404; border-color: #856404; }
</style>
