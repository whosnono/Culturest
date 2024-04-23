require 'sinatra'

get '/' do
  @current_date = Time.now.strftime("%d/%m/%Y")
  erb :index
end

post '/register' do
  expediente = params[:expediente]
  File.open('evento.txt', 'a') { |file| file.puts(expediente) }
  "Se ha inscrito al evento Hackathon 2025 con el expediente #{expediente}"
end