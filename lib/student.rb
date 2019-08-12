require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.new_from_db
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    self.new
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE students"
    
    DB[:conn].execute(sql)
  end
  
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL
      
      DB[:conn].execute(sql, self.name, self.grade)
      
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
 def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
 end
  
  
end
