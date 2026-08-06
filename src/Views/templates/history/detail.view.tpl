<div class="container-m py-5">

  <div style="margin-bottom:1rem;">
    <a href="{{returnUrl}}" style="color:#666;text-decoration:none;">
      <i class="fas fa-arrow-left"></i>&nbsp;{{returnText}}
    </a>
  </div>

  {{with pedido}}
  <div class="row align-center" style="margin-bottom:0.25rem;">
    <h2 style="margin:0;flex:1;">Orden #{{id}}</h2>
  </div>
  <p style="color:#666;margin-bottom:1rem;">Realizada el {{fecha}}</p>

  <div class="row align-center" style="gap:0.6rem;margin-bottom:1.5rem;flex-wrap:wrap;">
    {{if isAPR}}<span class="bp-status-badge bp-badge-act" style="font-size:0.85rem;">Aprobado</span>{{endif isAPR}}
    {{if isPND}}<span class="bp-status-badge bp-badge-pnd" style="font-size:0.85rem;">Pendiente</span>{{endif isPND}}
    {{if isRCH}}<span class="bp-status-badge bp-badge-ina" style="font-size:0.85rem;">Rechazado</span>{{endif isRCH}}
    {{if isCAN}}<span class="bp-status-badge bp-badge-ago" style="font-size:0.85rem;">Cancelado</span>{{endif isCAN}}
    <a href="index.php?page=History_Export&type=detail&id={{id}}" class="bp-btn-cta" style="font-size:0.85rem;padding:0.5rem 1.1rem;">
      <i class="fas fa-file-csv"></i>&nbsp;Exportar CSV
    </a>
    <button onclick="window.print()" class="bp-btn-outline" style="font-size:0.85rem;padding:0.5rem 1.1rem;border:none;cursor:pointer;">
      <i class="fas fa-print"></i>&nbsp;Imprimir / Guardar PDF
    </button>
  </div>

  <h3 style="font-size:1.05rem;margin-bottom:0.5rem;"><i class="fas fa-receipt"></i>&nbsp;Resumen de Pago</h3>
  <hr style="margin:0 0 0.75rem;" />
  <p style="margin-bottom:0.4rem;"><strong>Método de Pago:</strong> {{metodoPago}}</p>
  {{if referenciaPasarela}}
  <p style="margin-bottom:0.4rem;"><strong>Ref. PayPal / Pasarela:</strong> <code>{{referenciaPasarela}}</code></p>
  {{endif referenciaPasarela}}
  <p style="margin-bottom:1.5rem;"><strong>Monto Total:</strong> L. {{total}}</p>
  {{endwith pedido}}

  <h3 style="font-size:1.05rem;margin-bottom:0.75rem;"><i class="fas fa-boxes"></i>&nbsp;Productos en esta orden</h3>
  <div class="WWList">
    <table>
      <thead>
        <tr>
          <th>Producto</th>
          <th>Cantidad</th>
          <th>Precio Unitario</th>
          <th>Subtotal</th>
        </tr>
      </thead>
      <tbody>
        {{foreach detalle}}
        <tr>
          <td>
            <div class="row align-center" style="gap:0.75rem;">
              <div class="bp-ac-img">
                {{if productImgUrl}}
                <img src="{{~BASE_DIR}}/public/imgs/products/{{productImgUrl}}" alt="{{productName}}" />
                {{endif productImgUrl}}
                {{ifnot productImgUrl}}
                <div class="bp-ac-placeholder"><i class="fas fa-dumbbell"></i></div>
                {{endifnot productImgUrl}}
              </div>
              <div>
                <strong>{{productName}}</strong>
                <div style="color:#888;font-size:0.85rem;">ID: {{productId}}</div>
              </div>
            </div>
          </td>
          <td>{{cantidad}}</td>
          <td>L. {{precioUnitario}}</td>
          <td><strong>L. {{subtotal}}</strong></td>
        </tr>
        {{endfor detalle}}
      </tbody>
      <tfoot>
        <tr>
          <td colspan="3" style="text-align:right;"><strong>Total del Pedido:</strong></td>
          <td><strong>L. {{subtotalGeneral}}</strong></td>
        </tr>
      </tfoot>
    </table>
  </div>

</div>
