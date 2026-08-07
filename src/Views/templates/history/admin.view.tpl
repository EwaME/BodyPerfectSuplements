<div class="container-m py-5">

  <div class="row align-center" style="margin-bottom:1.5rem;">
    <div style="flex:1;">
      <h2 style="margin:0;"><i class="fas fa-tasks"></i>&nbsp;Transacciones Globales</h2>
      <p style="color:#666;margin:0.35rem 0 0;">Supervisión y auditoría consolidada de todas las órdenes y compras.</p>
    </div>
    {{if hasTransacciones}}
    <div style="display:flex;gap:0.6rem;flex-wrap:wrap;">
      <a href="index.php?page=History_Export&type=admin&q={{search}}&estado={{estado}}&fechaInicio={{fechaInicio}}&fechaFin={{fechaFin}}" class="bp-btn-cta" style="font-size:0.9rem;padding:0.6rem 1.2rem;">
        <i class="fas fa-file-csv"></i>&nbsp;Exportar CSV
      </a>
      <button onclick="window.print()" type="button" class="bp-btn-outline" style="font-size:0.9rem;">
        <i class="fas fa-print"></i>&nbsp;Imprimir
      </button>
    </div>
    {{endif hasTransacciones}}
  </div>

  <form method="GET" action="index.php" class="bp-filter-card">
    <input type="hidden" name="page" value="History_Admin" />
    <div class="bp-filter-grid">
      <div class="bp-filter-field">
        <label>Búsqueda general</label>
        <input type="text" name="q" value="{{search}}" placeholder="Cliente, correo, # orden o ref..." />
      </div>
      <div class="bp-filter-field">
        <label>Estado</label>
        <select name="estado">
          <option value="ALL" {{if isFilterAll}}selected{{endif isFilterAll}}>Todos los estados</option>
          <option value="APR" {{if isFilterAPR}}selected{{endif isFilterAPR}}>Aprobados</option>
          <option value="PND" {{if isFilterPND}}selected{{endif isFilterPND}}>Pendientes</option>
          <option value="RCH" {{if isFilterRCH}}selected{{endif isFilterRCH}}>Rechazados</option>
        </select>
      </div>
      <div class="bp-filter-field">
        <label>Desde</label>
        <input type="date" name="fechaInicio" value="{{fechaInicio}}" />
      </div>
      <div class="bp-filter-field">
        <label>Hasta</label>
        <input type="date" name="fechaFin" value="{{fechaFin}}" />
      </div>
      <div class="bp-filter-field bp-filter-submit">
        <button type="submit" class="primary"><i class="fas fa-search"></i>&nbsp;Filtrar</button>
      </div>
    </div>
  </form>

  {{if hasTransacciones}}
  <div class="bp-admin-result-info">
    <span>{{total}} transacción(es) encontrada(s)</span>
  </div>

  <div class="WWList">
    <table>
      <thead>
        <tr>
          <th># Orden</th>
          <th>Cliente / Correo</th>
          <th>Fecha</th>
          <th>Método / Ref</th>
          <th>Items</th>
          <th>Monto Total</th>
          <th>Estado</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        {{foreach transacciones}}
        <tr>
          <td><strong>#{{id}}</strong></td>
          <td>
            <div><strong>{{username}}</strong></div>
            <div class="bp-cell-sub">{{useremail}}</div>
          </td>
          <td>{{fecha}}</td>
          <td>
            <div><i class="fab fa-paypal"></i>&nbsp;{{metodoPago}}</div>
            {{if referenciaPasarela}}<div class="bp-cell-sub bp-cell-mono">{{referenciaPasarela}}</div>{{endif referenciaPasarela}}
          </td>
          <td>{{totalItems}} item(s)</td>
          <td><strong>L. {{total}}</strong></td>
          <td><span class="bp-status-badge {{estadoBadge}}">{{estadoText}}</span></td>
          <td class="bp-admin-actions">
            <a href="index.php?page=History_Detail&id={{id}}&from=admin" class="bp-btn-admin bp-btn-edit" title="Ver detalle">
              <i class="fas fa-eye"></i>
            </a>
          </td>
        </tr>
        {{endfor transacciones}}
      </tbody>
    </table>
  </div>

  {{if totalPages}}
  <div class="bp-pagination" style="margin-top:1.25rem;">
    {{if hasPrev}}
    <a href="index.php?page=History_Admin&p={{prevPage}}&q={{search}}&estado={{estado}}&fechaInicio={{fechaInicio}}&fechaFin={{fechaFin}}" class="bp-page-btn">
      <i class="fas fa-chevron-left"></i>
    </a>
    {{endif hasPrev}}
    <span class="bp-page-info">Página {{page}} de {{totalPages}}</span>
    {{if hasNext}}
    <a href="index.php?page=History_Admin&p={{nextPage}}&q={{search}}&estado={{estado}}&fechaInicio={{fechaInicio}}&fechaFin={{fechaFin}}" class="bp-page-btn">
      <i class="fas fa-chevron-right"></i>
    </a>
    {{endif hasNext}}
  </div>
  {{endif totalPages}}

  {{endif hasTransacciones}}

  {{ifnot hasTransacciones}}
  <div class="bp-empty">
    <i class="fas fa-search"></i>
    <p>No existen registros que coincidan con los criterios o filtros seleccionados.</p>
  </div>
  {{endifnot hasTransacciones}}

</div>

<style>
.bp-btn-outline {
  display: inline-flex;
  align-items: center;
  background: #fff;
  color: #333 !important;
  border: 2px solid #999;
  padding: 0.6rem 1.2rem;
  font-weight: 700;
  border-radius: 4px;
  cursor: pointer;
}
.bp-btn-outline:hover { background: #f2f2f2; }

.bp-filter-card {
  background: #fff;
  border-radius: 8px;
  border: 1px solid #e6e6e6;
  padding: 1.25rem;
  margin-bottom: 1.5rem;
}
.bp-filter-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 1rem;
  align-items: end;
}
.bp-filter-field label {
  display: block;
  font-size: 0.8rem;
  margin-bottom: 0.4rem;
  color: #555;
}
.bp-filter-field input,
.bp-filter-field select {
  width: 100%;
  box-sizing: border-box;
}
.bp-filter-submit button {
  width: 100%;
  justify-content: center;
}

.bp-admin-result-info {
  color: #666;
  font-size: 0.9rem;
  margin-bottom: 0.75rem;
}

.bp-cell-sub { color: #888; font-size: 0.8rem; }
.bp-cell-mono { font-family: monospace; }

.bp-badge-pnd { background: #fff3cd; color: #856404; }
</style>
