require 'sinatra'

get '/' do
  erb :index
end

__END__

@@ index
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Registro de Eventos Culturest</title>
    <link rel="stylesheet" href="styles.css">
    <script src="script.rb"></script>
  </head>

  <body>
    <div class="titulo">
      <img class="logos" src="assets/img/Escudo_Unison.png" alt="Logo UNISON" />
      <h1>Registro de Eventos Culturest</h1>
      <img class="logos" src="assets/img/LOGO_CULTUREST.png" alt="Logo CULTUREST" />
    </div>

    <div id="fecha"></div>

    <div class="conferencia">
      <h2>Eventos</h2>
      <h3>Hackathon 2025</h3>
    </div>

    <div class="expediente">
        <h4>Lea el expediente del alumno</h4>
        <h1 id="salida"></h1>
        <h2 id="evento"></h2>
    </div>
  </body>
</html>