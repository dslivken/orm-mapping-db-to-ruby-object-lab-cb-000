class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id=row[0]
    student.name=row[1]
    student.grade=row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      Select * from students
    SQL
    students = []
    DB[:conn].execute(sql).each do |r|
      students << self.new_from_db(r)
    end
    students
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      Select *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map do |r|
      self.new_from_db(r)
    end.first
  end

  def self.count_all_students_in_grade_9
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      Select *
      FROM students
      WHERE grade = 9
    SQL
    students = []
    DB[:conn].execute(sql).each do |r|
      students << self.new_from_db(r)
    end
    students
  end

  def self.students_below_12th_grade
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      Select *
      FROM students
      WHERE grade < 12
    SQL
    students = []
    DB[:conn].execute(sql).each do |r|
      students << self.new_from_db(r)
    end
    students
  end

  def self.first_x_students_in_grade_10 (x)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      Select *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL
    students = []
    DB[:conn].execute(sql, x).each do |r|
      students << self.new_from_db(r)
    end
    students
  end

  def self.first_student_in_grade_10
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      Select *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL
    DB[:conn].execute(sql).collect do |r|
      self.new_from_db(r)
    end.first
  end

  def self.all_students_in_grade_x (x)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      Select *
      FROM students
      WHERE grade = ?
    SQL
    students = []
    DB[:conn].execute(sql, x).each do |r|
      students << self.new_from_db(r)
    end
    students
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
