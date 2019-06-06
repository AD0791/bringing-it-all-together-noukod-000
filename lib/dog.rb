
require_relative "../config/environment.rb"
class Dog
  attr_accessor :name, :breed
  attr_reader :id
  
  # mass assignment
  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end
  
  # ruby to database
  # our class can create dogs table (obj map tables)
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
      )
      SQL
      
      DB[:conn].execute(sql)
  end
  
  # ruby to database
  # our class can drop the dogs table (obj map tables)
  def self.drop_table
    sql = <<-SQL 
      DROP TABLE dogs
      SQL
      
      DB[:conn].execute(sql)
  end
  
  # ruby to database
  # we can record an instance (instance map to column table)
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed) 
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end
  
  # ruby to database
  # custom constructor that will create and record new songs (obj map to tables)
  def self.create(name:, breed:)
    dog = Dog.new(name: name,breed: breed) #Dog.new 
    dog.save
    dog
  end
  
  # database to ruby
  # our class can access the records and return the row as an instance (objects) (database map object)
  def self.find_by_id(id:)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id:)[0]
    Dog.new(result[0], result[1], result[2])
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
end