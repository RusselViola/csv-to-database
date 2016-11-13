#YOUR CODE GOES HERE
require 'pg'
require 'csv'


def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end

csv = CSV.readlines('ingredients.csv')

db_connection do |conn|
  conn.exec("DROP TABLE IF EXISTS ingredients CASCADE")
  conn.exec("CREATE TABLE ingredients(
  id SERIAL PRIMARY KEY,
  ingredient VARCHAR(255)
  );")
  csv.each do |datum|
    conn.exec("INSERT INTO ingredients(ingredient)
    VALUES ($1)", [datum[1]])
  end
end
