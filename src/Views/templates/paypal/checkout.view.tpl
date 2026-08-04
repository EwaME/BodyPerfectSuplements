<div class="container-m py-5">

  <nav class="bp-breadcrumb">
    <a href="index.php">Inicio</a>
    <span>/</span>
    <a href="index.php?page=Checkout_Cart">Carrito</a>
    <span>/</span>
    <span>Confirmar pedido</span>
  </nav>

  <h2 class="bp-section-title" style="margin-bottom:1.25rem;">
    <i class="fas fa-lock"></i>&nbsp;Confirmar pedido
  </h2>

  <table class="bp-table">
    <thead>
      <tr>
        <th>Producto</th>
        <th>Cantidad</th>
        <th>Precio unitario</th>
        <th>Subtotal línea</th>
      </tr>
    </thead>
    <tbody>
      {{foreach items}}
      <tr>
        <td>{{productName}}</td>
        <td>{{crrctd}}</td>
        <td>L. {{crrprc}}</td>
        <td>L. {{lineaTotal}}</td>
      </tr>
      {{endfor items}}
    </tbody>
  </table>

  <div class="bp-cart-summary">
    <div class="bp-cart-summary-row">
      <span>Subtotal:</span>
      <span>L. {{subtotal}}</span>
    </div>
    <div class="bp-cart-summary-row">
      <span>ISV (15%):</span>
      <span>L. {{isv}}</span>
    </div>
    <div class="bp-cart-summary-row">
      <span>Envío:</span>
      <span>L. {{envio}}</span>
    </div>
    <div class="bp-cart-summary-row bp-cart-summary-total">
      <span>Total:</span>
      <span>L. {{total}}</span>
    </div>

    <form action="index.php?page=Checkout_Checkout" method="post">
      <button type="submit" class="bp-cart-checkout-btn">
        <i class="fab fa-paypal"></i>&nbsp;Pagar con PayPal
      </button>
    </form>
    <a href="index.php?page=Checkout_Cart" class="bp-cart-continue-link">
      <i class="fas fa-arrow-left"></i>&nbsp;Volver al carrito
    </a>
  </div>

</div>
