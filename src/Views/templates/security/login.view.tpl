<section class="fullCenter bp-auth">
  <form class="grid bp-auth-card" method="post" action="index.php?page=sec_login{{if redirto}}&redirto={{redirto}}{{endif redirto}}">
    <section class="depth-1 row col-12 bp-auth-head">
      <div class="col-12"><span class="bp-auth-icon"><i class="fas fa-sign-in-alt"></i></span></div>
      <h1 class="col-12">Iniciar Sesión</h1>
      <div class="col-12 bp-auth-subtitle">Bienvenido de vuelta a BodyPerfect</div>
    </section>
    <section class="depth-1 py-5 row col-12 bp-auth-body">
      <div class="row">
        <label class="col-12 col-m-4 flex align-center" for="txtEmail">Correo Electrónico</label>
        <div class="col-12 col-m-8">
          <input class="width-full" type="email" id="txtEmail" name="txtEmail" value="{{txtEmail}}" />
        </div>
        {{if errorEmail}}
          <div class="error col-12 py-2 col-m-8 offset-m-4">{{errorEmail}}</div>
        {{endif errorEmail}}
      </div>
      <div class="row">
        <label class="col-12 col-m-4 flex align-center" for="txtPswd">Contraseña</label>
        <div class="col-12 col-m-8">
         <input class="width-full" type="password" id="txtPswd" name="txtPswd" value="{{txtPswd}}" />
        </div>
        {{if errorPswd}}
        <div class="error col-12 py-2 col-m-8 offset-m-4">{{errorPswd}}</div>
        {{endif errorPswd}}
      </div>
    {{if generalError}}
      <div class="row">
        <div class="error col-12 py-2">{{generalError}}</div>
      </div>
    {{endif generalError}}
    <div class="row right flex-end px-4">
      <button class="primary" id="btnLogin" type="submit">Iniciar Sesión</button>
    </div>
    </section>
  </form>
</section>
