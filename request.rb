#1 Crear el método request que reciba una url y el api_key y devuelva el hash con los resultados.
api_url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key"
api_key = "zUn9D79drjqE9ybbxmTNHFinEoS2ybaIoTwYqfVg"

# 2. Crear un método llamado buid_web_page que reciba el hash de respuesta con todos
# los datos y construya una página web. Se evaluará la página creada y tiene que tener
# este formato:
# <html>
# <head>
# </head>
# <body>
# <ul>
# <li><img src='.../398380645PRCLF0030000CC AM04010L1.PNG'></li>
# <li><img src='.../398381687EDR_F0030000CCAM05010M_.JPG'></li>
# </ul>
# </body>
# </html>


require "uri"
require "net/http"
require "json"

#Se define el método request para llamar la api y transformarla a JSON

def request(url)
    url = URI(url)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    JSON.parse(response.read_body)


end

#Se define el método build_web_page para crear la página web con el formato solicitado
def build_web_page(data2)

    page = ""

    page += "<html>\n"
    page += "<head>\n"
    page += "</head>\n"
    page += "<body>\n"
    page += "<ul>\n"
    
    #se recorre el hash para obtener solo las keys "img_src" y se guardan en una variable
    photos = data2.map do |photo|
        photo["img_src"]
    end

    #se recorren las keys para ingresar la url de las imagenes
    photos.each do |photo|
        page += "\t<li><img src=#{photo}></li>\n"
    end

    page += "</ul>\n"
    page += "</body>\n"
    page += "</html>\n"
    return page
end

#Se deja en una variable el retorno del metodo request
data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=zUn9D79drjqE9ybbxmTNHFinEoS2ybaIoTwYqfVg")

#Se reducen a 10 los elementos del hash retornado
data = data["photos"][0..9]

File.write('index.html', build_web_page(data))