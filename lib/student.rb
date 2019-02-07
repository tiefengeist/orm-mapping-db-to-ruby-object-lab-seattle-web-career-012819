require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(id: nil, name: nil, grade: nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    newstudent = self.new(id: row[0], name: row[1], grade: row[2])
    newstudent
  end

  def self.all
    allrows = DB[:conn].execute("SELECT * FROM students")
    allrows.map do |row|
      self.new_from_db(row)
    end
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    namefind = DB[:conn].execute("SELECT * FROM students WHERE name = (?) LIMIT 1", name)
    namefind.map {|row| self.new_from_db(row)}.first
  end

  def self.all_students_in_grade_9
    ninefind = DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
    ninefind.map {|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    belowfind = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    belowfind.map {|row| self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(num)
    firstxfind = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT (?)", num)
    firstxfind.map {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    firstfind = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")
    firstfind.map {|row| self.new_from_db(row)}.first
  end

  def self.all_students_in_grade_X(num)
    allxfind = DB[:conn].execute("SELECT * FROM students WHERE grade = (?)", num)
    allxfind.map {|row| self.new_from_db(row)}
  end



  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
