<section class="container-m py-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h1 class="h2 font-weight-bold mb-1"><i class="fas fa-tasks text-primary"></i>&nbsp;Panel Admin: Transacciones del Sistema</h1>
      <p class="text-muted mb-0">Supervisión y auditoría consolidada de todas las ordenes y compras.</p>
    </div>
  </div>

  <div class="card mb-4 shadow-sm border-0">
    <div class="card-body p-3">
      <form action="index.php" method="get" class="row g-3 align-items-end">
        <input type="hidden" name="page" value="History_Admin" />
        
        <div class="col-md-3">
          <label class="form-label font-weight-bold">Búsqueda general</label>
          <input type="text" name="q" value="{{search}}" placeholder="Cliente, correo, # orden o ref..." class="form-control" />
        </div>

        <div class="col-md-3">
          <label class="form-label font-weight-bold">Estado</label>
          <select name="estado" class="form-control">
            <option value="ALL" {{if isFilterAll}}selected{{endif isFilterAll}}>Todos los estados</option>
            <option value="APR" {{if isFilterAPR}}selected{{endif isFilterAPR}}>Aprobados</option>
            <option value="PND" {{if isFilterPND}}selected{{endif isFilterPND}}>Pendientes</option>
            <option value="RCH" {{if isFilterRCH}}selected{{endif isFilterRCH}}>Rechazados</option>
          </select>
        </div>

        <div class="col-md-2">
          <label class="form-label font-weight-bold">Desde</label>
          <input type="date" name="fechaInicio" value="{{fechaInicio}}" class="form-control" />
        </div>

        <div class="col-md-2">
          <label class="form-label font-weight-bold">Hasta</label>
          <input type="date" name="fechaFin" value="{{fechaFin}}" class="form-control" />
        </div>

        <div class="col-md-2 d-flex gap-2">
          <button type="submit" class="btn btn-primary w-100"><i class="fas fa-search"></i>&nbsp;Filtrar</button>
        </div>
      </form>
    </div>
  </div>

  {{if hasTransacciones}}
  <div class="table-responsive bg-white rounded shadow-sm border mb-4">
    <table class="table table-hover align-middle mb-0">
      <thead class="thead-light">
        <tr>
          <th># Orden</th>
          <th>Cliente / Correo</th>
          <th>Fecha</th>
          <th>Método / Ref</th>
          <th>Items</th>
          <th>Monto Total</th>
          <th>Estado</th>
        </tr>
      </thead>
      <tbody>
        {{foreach transacciones}}
        <tr>
          <td><strong>#{{id}}</strong></td>
          <td>
            <div><strong>{{username}}</strong></div>
            <div class="text-muted small">{{useremail}}</div>
          </td>
          <td>{{fecha}}</td>
          <td>
            <div><span class="badge badge-light text-dark"><i class="fab fa-paypal text-info"></i>&nbsp;{{metodoPago}}</span></div>
            {{if referenciaPasarela}}<small class="text-muted font-monospace">{{referenciaPasarela}}</small>{{endif referenciaPasarela}}
          </td>
          <td>{{totalItems}} item(s)</td>
          <td><strong class="text-primary">L. {{total}}</strong></td>
          <td>
            <span class="badge {{estadoBadge}} p-2">{{estadoText}}</span>
          </td>
        </tr>
        {{endfor transacciones}}
      </tbody>
    </table>
  </div>

  {{if totalPages}}
  <nav aria-label="Navegación de páginas admin">
    <ul class="pagination justify-content-center">
      {{if hasPrev}}
      <li class="page-item">
        <a class="page-link" href="index.php?page=History_Admin&p={{prevPage}}&q={{search}}&estado={{estado}}&fechaInicio={{fechaInicio}}&fechaFin={{fechaFin}}"><i class="fas fa-chevron-left"></i> Anterior</a>
      </li>
      {{endif hasPrev}}
      <li class="page-item disabled">
        <span class="page-link">Página {{page}} de {{totalPages}}</span>
      </li>
      {{if hasNext}}
      <li class="page-item">
        <a class="page-link" href="index.php?page=History_Admin&p={{nextPage}}&q={{search}}&estado={{estado}}&fechaInicio={{fechaInicio}}&fechaFin={{fechaFin}}">Siguiente <i class="fas fa-chevron-right"></i></a>
      </li>
      {{endif hasNext}}
    </ul>
  </nav>
  {{endif totalPages}}

  {{endif hasTransacciones}}

  {{ifnot hasTransacciones}}
  <div class="card text-center p-5 border-0 shadow-sm">
    <div class="card-body">
      <i class="fas fa-search text-muted mb-3" style="font-size: 3rem;"></i>
      <h3 class="h4">No se encontraron transacciones</h3>
      <p class="text-muted">No existen registros que coincidan con los criterios o filtros seleccionados.</p>
    </div>
  </div>
  {{endifnot hasTransacciones}}
</section>
