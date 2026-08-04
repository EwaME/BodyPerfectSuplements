<div class="container-m py-5">

  {{if pedido}}
  <h1><i class="fas fa-circle-check"></i>&nbsp;¡Gracias por tu compra!</h1>
  {{with pedido}}
  <p>Pedido #{{id}} — Estado: {{estado}}</p>
  <p>Total: L. {{total}}</p>
  <p>Fecha: {{fecha}}</p>
  {{endwith pedido}}
  <table class="bp-table">
    <thead>
      <tr>
        <th>Producto</th>
        <th>Cantidad</th>
        <th>Precio unitario</th>
      </tr>
    </thead>
    <tbody>
      {{foreach detalle}}
      <tr>
        <td>{{productName}}</td>
        <td>{{cantidad}}</td>
        <td>L. {{precioUnitario}}</td>
      </tr>
      {{endfor detalle}}
    </tbody>
  </table>
  {{endif pedido}}

  {{ifnot pedido}}
  <h1>No hay orden disponible</h1>
  <p>No encontramos una orden asociada a esta confirmación.</p>
  {{endifnot pedido}}

  <a href="index.php?page=Products_Products" class="bp-cart-continue-link">
    <i class="fas fa-store"></i>&nbsp;Seguir comprando
  </a>

</div>
