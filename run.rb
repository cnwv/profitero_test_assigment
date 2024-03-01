require_relative './parser'

url = "https://www.petsonic.com/dermatitis-y-problemas-piel-para-perros/"
file = "output.csv"
parser = Parser.new(url, file)
parser.run
