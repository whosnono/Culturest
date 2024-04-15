require 'sinatra'

get '/' do
  erb :index
end

post '/event' do
  expediente = params[:expediente]
  File.open('event.txt', 'a') { |f| f.puts expediente }
  "#{expediente} Se ha inscrito al evento Hackathon 2025"
end

__END__

@@ index
<!DOCTYPE html>
<html>
  <head>
    <title>Registro de Eventos Culturest</title>
    <link rel="stylesheet" href="styles.css">
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        document.addEventListener('keyup', function(e) {
          if (e.key === 'Enter') {
            var expediente = document.getElementById('expediente').value;
            fetch('/event', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: 'expediente=' + expediente
            })
            .then(function(response) {
              return response.text();
            })
            .then(function(data) {
              document.getElementById('evento').textContent = data;
              document.getElementById('expediente').value = '';
            });
          }
        });
      });
    </script>
  </head>
  <body>
    <div class="expediente">
      <h4>Lea el expediente del alumno</h4>
      <input type="text" id="expediente" placeholder="Ingrese el expediente">
      <h2 id="evento"></h2>
    </div>
  </body>
</html>