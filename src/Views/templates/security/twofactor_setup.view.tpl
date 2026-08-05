<section class="fullCenter bp-auth">
  <section class="bp-auth-card">
  <section class="depth-1 row col-12 bp-auth-head">
    <div class="col-12"><span class="bp-auth-icon"><i class="fas fa-shield-alt"></i></span></div>
    <h1 class="col-12">Verificación en Dos Pasos (2FA)</h1>
    <div class="col-12 bp-auth-subtitle">Protege tu cuenta de administrador</div>
  </section>

  {{if activado}}
  <section class="depth-1 py-5 row col-12 bp-auth-body">
    {{if ok}}
    <div class="row col-12 py-2 bp-auth-ok">2FA activado correctamente. Tu cuenta ahora requiere un código de tu app de autenticación en cada inicio de sesión.</div>
    {{endif ok}}
    <div class="row col-12 py-2 bp-auth-status"><i class="fas fa-check-circle"></i> El doble factor de autenticación está <strong>&nbsp;activo</strong> en tu cuenta.</div>
    <form method="post" action="index.php?page=sec_twofactorsetup">
      <input type="hidden" name="accion" value="desactivar" />
      <div class="row right flex-end px-4">
        <button class="primary" type="submit">Desactivar 2FA</button>
      </div>
    </form>
  </section>
  {{endif activado}}

  {{ifnot activado}}
  <section class="depth-1 py-5 row col-12 bp-auth-body">
    {{if ok}}
    <div class="row col-12 py-2 bp-auth-ok">2FA desactivado.</div>
    {{endif ok}}
    <ol class="col-12 bp-auth-steps">
      <li>Instala una app de autenticación (Google Authenticator, Authy, etc.) en tu teléfono.</li>
      <li>
        Agrega una cuenta nueva usando la <strong>clave manual</strong> (Setup Key):
        <code class="bp-auth-secret">{{secret}}</code>
      </li>
      <li>
        URI de configuración (algunas apps permiten pegarla directamente):
        <small class="width-full" style="word-break:break-all;">{{otpauthUrl}}</small>
      </li>
      <li>Ingresa el código de 6 dígitos que muestra la app para confirmar la activación:</li>
    </ol>
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
</section>
