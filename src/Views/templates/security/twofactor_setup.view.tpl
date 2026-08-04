<section class="fullCenter">
  <section class="depth-1 row col-12 col-m-8 offset-m-2 col-xl-6 offset-xl-3">
    <h1 class="col-12">Verificación en Dos Pasos (2FA)</h1>
  </section>

  {{if activado}}
  <section class="depth-1 py-5 row col-12 col-m-8 offset-m-2 col-xl-6 offset-xl-3">
    {{if ok}}
    <div class="row col-12 py-2">2FA activado correctamente. Tu cuenta ahora requiere un código de tu app de autenticación en cada inicio de sesión.</div>
    {{endif ok}}
    <div class="row col-12 py-2">El doble factor de autenticación está <strong>activo</strong> en tu cuenta.</div>
    <form method="post" action="index.php?page=sec_twofactorsetup">
      <input type="hidden" name="accion" value="desactivar" />
      <div class="row right flex-end px-4">
        <button class="primary" type="submit">Desactivar 2FA</button>
      </div>
    </form>
  </section>
  {{endif activado}}

  {{ifnot activado}}
  <section class="depth-1 py-5 row col-12 col-m-8 offset-m-2 col-xl-6 offset-xl-3">
    {{if ok}}
    <div class="row col-12 py-2">2FA desactivado.</div>
    {{endif ok}}
    <div class="row col-12 py-2">
      1. Instala una app de autenticación (Google Authenticator, Authy, etc.) en tu teléfono.
    </div>
    <div class="row col-12 py-2">
      2. Agrega una cuenta nueva usando la <strong>clave manual</strong> (Setup Key):
    </div>
    <div class="row col-12 py-2">
      <code class="width-full">{{secret}}</code>
    </div>
    <div class="row col-12 py-2">
      URI de configuración (algunas apps permiten pegarla directamente): <br />
      <small class="width-full" style="word-break:break-all;">{{otpauthUrl}}</small>
    </div>
    <div class="row col-12 py-2">
      3. Ingresa el código de 6 dígitos que muestra la app para confirmar la activación:
    </div>
    {{if error}}
    <div class="error col-12 py-2">{{error}}</div>
    {{endif error}}
    <form method="post" action="index.php?page=sec_twofactorsetup">
      <input type="hidden" name="accion" value="activar" />
      <div class="row">
        <label class="col-12 col-m-4 flex align-center" for="txtCodigo">Código</label>
        <div class="col-12 col-m-8">
          <input class="width-full" type="text" id="txtCodigo" name="txtCodigo" inputmode="numeric" pattern="\d{6}" maxlength="6" required autocomplete="one-time-code" />
        </div>
      </div>
      <div class="row right flex-end px-4">
        <button class="primary" type="submit">Activar 2FA</button>
      </div>
    </form>
  </section>
  {{endifnot activado}}
</section>
