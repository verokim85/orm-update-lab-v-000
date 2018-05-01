require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students(name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    # @id = DB[:conn].execute("SELECT last_insert_rowid () FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE name = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.name)
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end


  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    SQL

    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[0], result[1], result[2])

  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

end
