
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
  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    Dog.new(id: result[0], name: result[1], breed: result[2])
  end
  
  #database to ruby
  # ruby to database
  # this class method can do both
  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !dog.empty?
      dog_data = dog[0]
      dog = Dog.new(id: dog_data[0], name: dog_data[1], breed: dog_data[2])
    else
      dog = Dog.create(name: name, breed: breed)
    end
    dog
  end 
  
  # database to ruby (handler)
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    breed = row[2]
    self.new(id: id, name: name, breed: breed)
  end

  # database to ruby
=begin
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end
=end
  # no handler
  def self.find_by_name(name)
    sql = "SELECT * FROM dogs WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Dog.new(id: result[0], name: result[1], breed: result[2])
  end
  
  
  
  # ruby to database
  # instance can update a record (instance maps to row of tables)
  def update
    sql = "UPDATE dogs SET name = ?, breed = ?  WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  
  
end