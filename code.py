from geopy.geocoders import Nominatim
import time

try:
    city_list = [
        "Athina",
        "Paris",
        "St. Louis",
        "London",
        "Stockholm",
        "Antwerpen",
        "Chamonix",
        "Amsterdam",
        "Sankt Moritz",
        "Los Angeles",
        "Lake Placid",
        "Berlin",
        "Garmisch-Partenkirchen",
        "Helsinki",
        "Oslo",
        "Cortina d'Ampezzo",
        "Melbourne",
        "Squaw Valley",
        "Roma",
        "Innsbruck",
        "Tokyo",
        "Mexico City",
        "Grenoble",
        "Munich",
        "Sapporo",
        "Montreal",
        "Moskva",
        "Sarajevo",
        "Calgary",
        "Seoul",
        "Barcelona",
        "Albertville",
        "Lillehammer",
        "Atlanta",
        "Nagano",
        "Sydney",
        "Salt Lake City",
        "Torino",
        "Beijing",
        "Vancouver",
        "Sochi",
        "Rio de Janeiro"]
    
    count = 0
    geolocator = Nominatim(user_agent="whatever")
    for city in city_list:
        if count%15 == 14:
            time.sleep(3)
        
        city_info = geolocator.geocode(city)
        count +=1
        print(city + ", " + str(city_info.latitude) + ", " +  str(city_info.longitude))

except:
    print("Exception occured!")
    print("Last city information retreived - ", city_list[city_list.index(city) - 1])
