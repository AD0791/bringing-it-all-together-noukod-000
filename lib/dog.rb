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
    sql = <<-SQL CREATE TABLE IF NOT EXITS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
      )
      SQL
      
      DB[:conn].execute(sql)
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
end