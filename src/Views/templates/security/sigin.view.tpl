<section class="fullCenter">
  <form class="grid" method="post" action="index.php?page=sec_register">
    <section class="depth-1 row col-12 col-m-8 offset-m-2 col-xl-6 offset-xl-3">
      <h1 class="col-12">Crea tu cuenta</h1>
    </section>
    <section class="depth-1 py-5 row col-12 col-m-8 offset-m-2 col-xl-6 offset-xl-3">
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
          <input
            class="width-full"
            type="password"
            id="txtPswd"
            name="txtPswd"
            value="{{txtPswd}}"
            required
            minlength="8"
            maxlength="32"
            pattern="^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[^\w\d\s:])(\S){8,32}$"
            title="Mínimo 8 caracteres, con al menos 1 mayúscula, 1 minúscula, 1 número y 1 símbolo especial."
          />
          <small class="col-12 hint">Mínimo 8 caracteres: 1 mayúscula, 1 minúscula, 1 número y 1 símbolo especial.</small>
        </div>
        {{if errorPswd}}
        <div class="error col-12 py-2 col-m-8 offset-m-4">{{errorPswd}}</div>
        {{endif errorPswd}}
      </div>
      <div class="row right flex-end px-4">
        <button class="primary" id="btnSignin" type="submit">Crear Cuenta</button>
      </div>
    </section>
  </form>
</section>
