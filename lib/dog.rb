
class Dog

  attr_accessor :name, :breed, :id

  def initialize( name:,
                  breed:, 
                  id: nil )
    @name = name
    @breed = breed
    @id = id
  end
  
  def save
    dogs_name = self.name
    dogs_breed = self.breed
    dogs_id = self.id
    
    sql_insert = "INSERT INTO dogs(name, breed) VALUES('#{dogs_name}', '#{dogs_breed}'"
    sql_update = "UPDATE dogs SET name = '#{dogs_name}' WHERE id = '#{dogs_id}'"
    
    if dogs_id != nil
      DB[:conn].execute(sql_update)
    elsif dogs_id == nil
      DB[:conn].execute(sql_insert)
      @id = last_insert_rowid
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
end