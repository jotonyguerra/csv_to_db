require 'pg'
require 'csv'
system "psql ingredients < schema.sql"
def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end
# def add_csv
  csv_records = CSV.readlines('ingredients.csv', headers: true)
# your code, here
  CSV.foreach("ingredients.csv", headers: true) do |row|
    db_connection do |conn|
      query = "INSERT INTO items (num, ingredient) VALUES ($1,$2)"
      value = [row["num"], row["ingredient"]]
      conn.exec_params(query, value)
    end
  end
# end
#
# add_csv.each do
