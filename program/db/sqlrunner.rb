require('pg')


class SqlRunner


  def run(sql, values = [])
    begin
      db = PG.connect(dbname: 'burger_deals', host: 'localhost')
      db.prepare("run", sql)
      result = db.exec_prepared("run", values)
    ensure
      db.close if db != nil
    end
    return result
  end


end
