<section class="fullCenter bp-auth">
  <form class="grid bp-auth-card" method="post" action="index.php?page=sec_twofactorverify">
    <section class="depth-1 row col-12 bp-auth-head">
      <div class="col-12"><span class="bp-auth-icon"><i class="fas fa-shield-alt"></i></span></div>
      <h1 class="col-12">Verificación en Dos Pasos</h1>
      <div class="col-12 bp-auth-subtitle">Confirma tu identidad para continuar</div>
    </section>
    <section class="depth-1 py-5 row col-12 bp-auth-body">
      <div class="row col-12 py-2">Ingresa el código de 6 dígitos de tu app de autenticación.</div>
      <div class="row">
        <label class="col-12 col-m-4 flex align-center" for="txtCodigo">Código</label>
        <div class="col-12 col-m-8">
          <input class="width-full" type="text" id="txtCodigo" name="txtCodigo" inputmode="numeric" pattern="\d{6}" maxlength="6" required autocomplete="one-time-code" autofocus />
        </div>
        {{if errorCode}}
        <div class="error col-12 py-2 col-m-8 offset-m-4">{{errorCode}}</div>
        {{endif errorCode}}
      </div>
      <div class="row right flex-end px-4">
        <button class="primary" id="btnVerify2fa" type="submit">Verificar</button>
      </div>
    </section>
  </form>
</section>
