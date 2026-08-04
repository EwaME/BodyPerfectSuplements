<section class="container-m py-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h1 class="h2 font-weight-bold mb-1"><i class="fas fa-history text-primary"></i>&nbsp;Histórico de Transacciones</h1>
      <p class="text-muted mb-0">Revisa tus compras realizadas y el estado de cada pedido.</p>
    </div>
    {{if hasPedidos}}
    <div>
      <a href="index.php?page=History_Export&type=history&estado={{estado}}" class="btn btn-outline-secondary">
        <i class="fas fa-file-csv"></i>&nbsp;Exportar CSV
      </a>
    </div>
    {{endif hasPedidos}}
  </div>

  <div class="card mb-4 shadow-sm border-0">
    <div class="card-body p-3">
      <form action="index.php" method="get" class="form-inline d-flex flex-wrap gap-2">
        <input type="hidden" name="page" value="History_History" />
        <label class="mr-2 font-weight-bold">Filtrar por estado:</label>
        <select name="estado" class="form-control mr-2 mb-2 mb-md-0" onchange="this.form.submit()">
          <option value="ALL" {{if isFilterAll}}selected{{endif isFilterAll}}>Todos los estados</option>
          <option value="APR" {{if isFilterAPR}}selected{{endif isFilterAPR}}>Aprobados</option>
          <option value="PND" {{if isFilterPND}}selected{{endif isFilterPND}}>Pendientes</option>
          <option value="RCH" {{if isFilterRCH}}selected{{endif isFilterRCH}}>Rechazados</option>
        </select>
        <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-filter"></i>&nbsp;Filtrar</button>
      </form>
    </div>
  </div>

  {{if hasPedidos}}
  <div class="table-responsive bg-white rounded shadow-sm border mb-4">
    <table class="table table-hover align-middle mb-0">
      <thead class="thead-light">
        <tr>
          <th># Orden</th>
          <th>Fecha</th>
          <th>Método</th>
          <th>Total de Ítems</th>
          <th>Monto Total</th>
          <th>Estado</th>
          <th class="text-right">Acciones</th>
        </tr>
      </thead>
      <tbody>
        {{foreach pedidos}}
        <tr>
          <td><strong>#{{id}}</strong></td>
          <td>{{fecha}}</td>
          <td>
            <span class="badge badge-light text-dark"><i class="fab fa-paypal text-info"></i>&nbsp;{{metodoPago}}</span>
          </td>
          <td>{{totalItems}} producto(s)</td>
          <td><strong class="text-primary">L. {{total}}</strong></td>
          <td>
            <span class="badge {{estadoBadge}} p-2">{{estadoText}}</span>
          </td>
          <td class="text-right">
            <a href="index.php?page=History_Detail&id={{id}}" class="btn btn-sm btn-info" title="Ver detalle">
              <i class="fas fa-eye"></i>&nbsp;Detalle
            </a>
          </td>
        </tr>
        {{endfor pedidos}}
      </tbody>
    </table>
  </div>

  {{if totalPages}}
  <nav aria-label="Navegación de páginas">
    <ul class="pagination justify-content-center">
      {{if hasPrev}}
      <li class="page-item">
        <a class="page-link" href="index.php?page=History_History&p={{prevPage}}&estado={{estado}}"><i class="fas fa-chevron-left"></i> Anterior</a>
      </li>
      {{endif hasPrev}}
      <li class="page-item disabled">
        <span class="page-link">Página {{page}} de {{totalPages}}</span>
      </li>
      {{if hasNext}}
      <li class="page-item">
        <a class="page-link" href="index.php?page=History_History&p={{nextPage}}&estado={{estado}}">Siguiente <i class="fas fa-chevron-right"></i></a>
      </li>
      {{endif hasNext}}
    </ul>
  </nav>
  {{endif totalPages}}

  {{endif hasPedidos}}

  {{ifnot hasPedidos}}
  <div class="card text-center p-5 border-0 shadow-sm">
    <div class="card-body">
      <i class="fas fa-shopping-bag text-muted mb-3" style="font-size: 3.5rem;"></i>
      <h3 class="h4">Aún no tienes compras registradas</h3>
      <p class="text-muted mb-4">Cuando realices pedidos en la tienda, aparecerán listados aquí para que puedas darles seguimiento.</p>
      <a href="index.php?page=Products_Products" class="btn btn-primary btn-lg">
        <i class="fas fa-store"></i>&nbsp;Ir al Catálogo de Productos
      </a>
    </div>
  </div>
  {{endifnot hasPedidos}}
</section>
