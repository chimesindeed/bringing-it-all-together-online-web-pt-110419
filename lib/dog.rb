require 'pry'

class Dog

  attr_accessor :name, :breed, :id
  @@all = []
  def self.all
    @@all
  end
  
  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end
  
def update(parameter)
  record=[]
  # update method takes parameter 'name'. 
  #update method SELECTS record from atabase
  binding.pry
end

  def self.find_by_id(int)
    row = (DB[:conn].execute("SELECT * FROM dogs WHERE id = ?", int)).flatten
    new_dog = Dog.new(id: row[0], name: row[1], breed: row[2])
    new_dog
  end
  
  def self.find_by_name(name)
    row = (DB[:conn].execute("SELECT * FROM dogs WHERE name = ?", name)).flatten
    new_dog = Dog.new(id: row[0], name: row[1], breed: row[2])
    new_dog
  end

  def self.new_from_db(row)
    instance = Dog.new(id: row[0], name: row[1], breed: row[2])
    instance
  end

  def save
    dogs_name = self.name
    dogs_breed = self.breed
    dogs_id = self.id
    
    sql_insert = "INSERT INTO dogs(name, breed) VALUES(?, ?)"
    sql_update = "UPDATE dogs SET name = ? WHERE id = ?"
    sql_get_last_insert = "SELECT last_insert_rowid() FROM dogs"
    
    if dogs_id == nil
      DB[:conn].execute(sql_insert, dogs_name, dogs_breed)
      @id =  DB[:conn].execute(sql_get_last_insert).flatten.join.to_i
      Dog.all << self
    elsif dogs_id != nil
      DB[:conn].execute(sql_update, dogs_name, dogs_id)
    end
    self
  end
  
  def self.create(name:, breed:)
    new_dog = Dog.new(name: name, breed: breed)
    new_dog.save
  end
    
  def self.drop_table
    sql_drop =  <<-SQL
        DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(sql_drop)
  end
  
  def self.create_table
    sql_create =  <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
    SQL
    DB[:conn].execute(sql_create)
  end
  
  def self.find_or_create_by(name:, breed:)
    sql = <<-SQL
          SELECT *
          FROM dogs
          WHERE name = ?
          AND breed = ?
          LIMIT 1
        SQL

    dog = DB[:conn].execute(sql,name,breed)

    if !dog.empty?
      dog_data = dog[0]
      dog = Dog.new(id: dog_data[0], name: dog_data[1], breed: dog_data[2])
    else
      dog = self.create(name: name, breed: breed)
    end
    dog
  end
end
#binding.pry