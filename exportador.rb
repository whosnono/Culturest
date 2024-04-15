require 'sinatra'
require 'json'

# Ruta para el formulario de carga de archivo
get '/' do
  erb :index
end

# Ruta para manejar la carga de archivos y mostrar la página de exportación
post '/upload' do
  file = params[:file]
  if file
    content = file[:tempfile].read.split("\n")
    erb :exportador, locals: { content: content }
  else
    erb :exportador, locals: { content: [] }
  end
end

# Ruta para descargar en diferentes formatos
get '/download/:format' do |format|
  content = params[:content]
  case format
  when 'csv'
    csv = content.map { |line| "#{line},a#{line}@unison.mx" }.join("\n")
    send_file("participantes.csv", type: 'text/csv', filename: 'participantes.csv')
  when 'json'
    json = content.map { |line| { expediente: line, correo: "a#{line}@unison.mx" } }
    send_file("participantes.json", type: 'application/json', filename: 'participantes.json')
  when 'sql'
    sql = <<~SQL
      CREATE DATABASE IF NOT EXISTS evento;
      USE evento;
      CREATE TABLE IF NOT EXISTS asistentes(expediente INT NOT NULL, correo VARCHAR(255) NOT NULL);
      #{content.map { |line| "INSERT INTO asistentes (expediente, correo) VALUES (#{line},'a#{line}@unison.mx');" }.join}
    SQL
    send_file("participantes.sql", type: 'text/plain', filename: 'participantes.sql')
  when 'xml'
    xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <asistentes>
      #{content.map { |line| "  <asistente>\n    <expediente>#{line}</expediente>\n    <correo>a#{line}@unison.mx</correo>\n  </asistente>" }}
      </asistentes>
    XML
    send_file("participantes.xml", type: 'application/xml', filename: 'participantes.xml')
  else
    status 404
    'Formato de descarga no válido'
  end
end

# Plantilla para la página de carga de archivo
__END__

@@ index
<!DOCTYPE html>
<html>
<head>
  <title>Cargar archivo con Ruby</title>
</head>
<body>
  <h1>Cargar archivo con Ruby</h1>
  <form action="/upload" method="post" enctype="multipart/form-data">
    <input type="file" name="file" />
    <input type="submit" value="Cargar archivo" />
  </form>
</body>
</html>

# Plantilla para la página de exportación
@@ exportador
<!DOCTYPE html>
<html>
<head>
  <title>Exportar datos</title>
</head>
<body>
  <h1>Exportar datos</h1>
  <pre><%= content.join("\n") %></pre>
  <a href="/download/csv">CSV</a>
  <a href="/download/json">JSON</a>
  <a href="/download/sql">SQL</a>
  <a href="/download/xml">XML</a>
</body>
</html>
