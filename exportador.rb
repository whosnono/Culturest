require 'sinatra'
require 'csv'

get '/' do
  erb :exportador
end

post '/upload' do
  content = params[:file][:tempfile].read
  @resultado = content
  erb :exportador
end

get '/generate/:format' do |format|
  content_type 'text/plain'
  case format
  when 'csv'
    generate_csv(params[:data])
  when 'json'
    generate_json(params[:data])
  when 'sql'
    generate_sql(params[:data])
  when 'xml'
    generate_xml(params[:data])
  else
    'Formato no soportado'
  end
end

def generate_csv(content)
  lines = content.split("\n")
  output = lines.map { |line| "#{line}, a#{line}@unison.mx" }
  content_type 'text/csv'
  attachment 'participantes.csv'
  output.join("\n")
end

def generate_json(content)
  lines = content.split("\n")
  data = lines.map { |line| { expediente: line, correo: "a#{line}@unison.mx"}}
  attachment 'participantes.json'
  data.to_json
end

def generate_sql(content)
  lines = content.split("\n")
  sql = "CREATE DATABASE IF NOT EXISTS evento;\nUSE evento;\nCREATE TABLE IF NOT EXISTS asistentes(expediente INT NOT NULL, correo VARCHAR(255) NOT NULL);\nINSERT INTO asistentes (expediente, correo) VALUES\n"
  lines.each { |line| sql += "('#{line}','a#{line}@unison.mx'),\n" }
  sql = sql.chomp(",\n") + ";"
  attachment 'participantes.sql'
  sql
end

def generate_xml(content)
  lines = content.split("\n")
  xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<asistentes>\n"
  lines.each { |line| xml += " <asistente>\n <expediente>#{line}</expediente>\n <correo>a#{line}@unison.mx</correo>\n </asistente>\n" }
  xml += "</asistentes>"
  attachment 'participantes.xml'
  xml
end
