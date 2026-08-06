<div class="container-m" style="padding: 2rem 1rem;">

  <h2 style="margin-bottom:1.5rem; font-size:1.6rem;">
    <i class="fas fa-chart-line"></i>&nbsp;Dashboard Administrativo
  </h2>

  <!-- Tarjetas de resumen -->
  <div class="grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap:1rem; margin-bottom:2rem;">
    <div class="bp-stat-card">
      <div class="bp-stat-icon" style="color:#10b981;"><i class="fas fa-money-bill-wave"></i></div>
      <div class="bp-stat-value">L. {{totalIngresos}}</div>
      <div class="bp-stat-label">Ingresos totales</div>
    </div>
    <div class="bp-stat-card">
      <div class="bp-stat-icon" style="color:#3b82f6;"><i class="fas fa-shopping-bag"></i></div>
      <div class="bp-stat-value">{{totalPedidos}}</div>
      <div class="bp-stat-label">Pedidos aprobados</div>
    </div>
    <div class="bp-stat-card">
      <div class="bp-stat-icon" style="color:#8b5cf6;"><i class="fas fa-users"></i></div>
      <div class="bp-stat-value">{{totalClientes}}</div>
      <div class="bp-stat-label">Clientes registrados</div>
    </div>
    <div class="bp-stat-card">
      <div class="bp-stat-icon" style="color:#f59e0b;"><i class="fas fa-boxes"></i></div>
      <div class="bp-stat-value">{{totalProductos}}</div>
      <div class="bp-stat-label">Productos activos</div>
    </div>
  </div>

  <!-- Gráficas -->
  <div class="grid" style="grid-template-columns: 1fr 1fr; gap:1.5rem; margin-bottom:2rem;">

    <div class="bp-chart-card">
      <h3><i class="fas fa-calendar-alt"></i>&nbsp;Ingresos últimos 7 días</h3>
      {{if hayVentas}}
      <canvas id="chartVentas" height="220"></canvas>
      {{endif hayVentas}}
      {{ifnot hayVentas}}
      <p class="bp-empty-chart">Sin ventas aprobadas en los últimos 7 días.</p>
      {{endifnot hayVentas}}
    </div>

    <div class="bp-chart-card">
      <h3><i class="fas fa-trophy"></i>&nbsp;Top 5 productos más vendidos</h3>
      {{if hayMasVendidos}}
      <canvas id="chartTop" height="220"></canvas>
      {{endif hayMasVendidos}}
      {{ifnot hayMasVendidos}}
      <p class="bp-empty-chart">Aún no hay ventas registradas.</p>
      {{endifnot hayMasVendidos}}
    </div>

  </div>

  <!-- Alertas de stock bajo -->
  {{if hayStockBajo}}
  <div class="bp-stock-alert">
    <h3><i class="fas fa-exclamation-triangle"></i>&nbsp;Alerta de stock bajo (≤ 10 unidades)</h3>
    <table class="bp-table" style="margin-top:1rem;">
      <thead>
        <tr><th>#</th><th>Producto</th><th>Stock</th><th>Acción</th></tr>
      </thead>
      <tbody>
        {{foreach stockBajo}}
        <tr class="{{if productStock == 0}}bp-row-agotado{{endif productStock}}">
          <td>{{productId}}</td>
          <td>{{productName}}</td>
          <td><strong style="color:#ef4444;">{{productStock}}</strong></td>
          <td><a href="index.php?page=Products_Edit&id={{productId}}" class="bp-btn-sm">Editar</a></td>
        </tr>
        {{endfor stockBajo}}
      </tbody>
    </table>
  </div>
  {{endif hayStockBajo}}

</div>

<style>
.bp-stat-card {
  background: #fff;
  border-radius: 12px;
  padding: 1.5rem;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0,0,0,.08);
}
.bp-stat-icon { font-size: 2rem; margin-bottom: .5rem; }
.bp-stat-value { font-size: 1.8rem; font-weight: 700; color: #1e293b; }
.bp-stat-label { color: #64748b; font-size: .875rem; margin-top: .25rem; }
.bp-chart-card {
  background: #fff;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,.08);
}
.bp-chart-card h3 { margin-bottom: 1rem; font-size: 1rem; color: #374151; }
.bp-empty-chart { color: #9ca3af; text-align: center; padding: 2rem 0; }
.bp-stock-alert {
  background: #fff;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,.08);
  border-left: 4px solid #f59e0b;
}
.bp-stock-alert h3 { color: #92400e; margin-bottom: .5rem; }
.bp-table { width: 100%; border-collapse: collapse; }
.bp-table th, .bp-table td { padding: .6rem 1rem; text-align: left; border-bottom: 1px solid #f1f5f9; }
.bp-table th { background: #f8fafc; font-size: .8rem; text-transform: uppercase; color: #64748b; }
.bp-row-agotado { background: #fef2f2; }
.bp-btn-sm {
  display: inline-block;
  padding: .25rem .75rem;
  background: #1e293b;
  color: #fff;
  border-radius: 6px;
  font-size: .8rem;
  text-decoration: none;
}
@media (max-width: 768px) {
  .grid[style*="1fr 1fr"] { grid-template-columns: 1fr !important; }
}
</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
(function() {
  var labelsVentas  = {{{jsonLabelsVentas}}};
  var dataIngresos  = {{{jsonDataIngresos}}};
  var labelsTop     = {{{jsonLabelsTop}}};
  var dataTop       = {{{jsonDataTop}}};

  if (document.getElementById('chartVentas')) {
    new Chart(document.getElementById('chartVentas'), {
      type: 'bar',
      data: {
        labels: labelsVentas,
        datasets: [{
          label: 'Ingresos (L.)',
          data: dataIngresos,
          backgroundColor: 'rgba(16,185,129,.7)',
          borderColor: 'rgb(16,185,129)',
          borderWidth: 1,
          borderRadius: 6
        }]
      },
      options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true } }
      }
    });
  }

  if (document.getElementById('chartTop')) {
    new Chart(document.getElementById('chartTop'), {
      type: 'bar',
      data: {
        labels: labelsTop,
        datasets: [{
          label: 'Unidades vendidas',
          data: dataTop,
          backgroundColor: 'rgba(59,130,246,.7)',
          borderColor: 'rgb(59,130,246)',
          borderWidth: 1,
          borderRadius: 6
        }]
      },
      options: {
        indexAxis: 'y',
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { x: { beginAtZero: true } }
      }
    });
  }
})();
</script>
