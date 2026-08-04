<section class="container-m py-4">
  <div class="mb-3">
    <a href="index.php?page=History_History" class="text-decoration-none text-muted">
      <i class="fas fa-arrow-left"></i>&nbsp;Volver al Histórico
    </a>
  </div>

  {{with pedido}}
  <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap">
    <div>
      <h1 class="h2 font-weight-bold mb-1">Orden #{{id}}</h1>
      <p class="text-muted mb-0">Realizada el {{fecha}}</p>
    </div>
    <div class="d-flex gap-2 align-items-center mt-2 mt-md-0">
      <span class="badge {{estadoBadge}} p-2 mr-2" style="font-size: 1rem;">{{estadoText}}</span>
      <a href="index.php?page=History_Export&type=detail&id={{id}}" class="btn btn-outline-secondary btn-sm">
        <i class="fas fa-file-csv"></i>&nbsp;Exportar CSV
      </a>
      <button onclick="window.print()" class="btn btn-outline-dark btn-sm">
        <i class="fas fa-print"></i>&nbsp;Imprimir
      </button>
    </div>
  </div>

  <div class="row mb-4">
    <div class="col-md-6 mb-3 mb-md-0">
      <div class="card h-100 shadow-sm border-0">
        <div class="card-body">
          <h5 class="card-title font-weight-bold"><i class="fas fa-receipt text-primary"></i>&nbsp;Resumen de Pago</h5>
          <hr />
          <p class="mb-1"><strong>Método de Pago:</strong> {{metodoPago}}</p>
          {{if referenciaPasarela}}
          <p class="mb-1"><strong>Ref. PayPal / Pasarela:</strong> <code>{{referenciaPasarela}}</code></p>
          {{endif referenciaPasarela}}
          <p class="mb-0"><strong>Monto Total:</strong> <span class="h5 text-primary mb-0 font-weight-bold">L. {{total}}</span></p>
        </div>
      </div>
    </div>
  </div>
  {{endwith pedido}}

  <div class="card shadow-sm border-0 mb-4">
    <div class="card-header bg-white font-weight-bold">
      <i class="fas fa-boxes"></i>&nbsp;Productos en esta orden
    </div>
    <div class="table-responsive">
      <table class="table table-hover align-middle mb-0">
        <thead class="thead-light">
          <tr>
            <th>Producto</th>
            <th class="text-center">Cantidad</th>
            <th class="text-right">Precio Unitario</th>
            <th class="text-right">Subtotal</th>
          </tr>
        </thead>
        <tbody>
          {{foreach detalle}}
          <tr>
            <td>
              <div class="d-flex align-items-center">
                {{if productImgUrl}}
                <img src="{{productImgUrl}}" alt="{{productName}}" class="img-thumbnail mr-3" style="width: 50px; height: 50px; object-fit: cover;" />
                {{endif productImgUrl}}
                <div>
                  <strong>{{productName}}</strong>
                  <div class="text-muted small">ID: {{productId}}</div>
                </div>
              </div>
            </td>
            <td class="text-center">
              <span class="badge badge-light px-3 py-2 border">{{cantidad}}</span>
            </td>
            <td class="text-right">L. {{precioUnitario}}</td>
            <td class="text-right font-weight-bold">L. {{subtotal}}</td>
          </tr>
          {{endfor detalle}}
        </tbody>
        <tfoot>
          <tr class="table-light">
            <td colspan="3" class="text-right font-weight-bold">Total del Pedido:</td>
            <td class="text-right font-weight-bold text-primary h5 mb-0">L. {{subtotalGeneral}}</td>
          </tr>
        </tfoot>
      </table>
    </div>
  </div>
</section>
