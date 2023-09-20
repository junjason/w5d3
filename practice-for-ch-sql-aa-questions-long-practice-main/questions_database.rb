class QuestionsDatabase < SQLite3::Database
    include Singleton
  
    def initialize
      super('questions.db')
      self.type_translation = true
      self.results_as_hash = true
    end
end

class Users
    attr_accessor :id, :fname, :lname
  
    def self.all
      data = QuestionsDatabase.instance.execute("SELECT * FROM users")
      data.map { |datum| Users.new(datum) }
    end
  
    def self.find_by_id(id)
      user = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          users
        WHERE
          id = ?
      SQL
      return nil unless user.length > 0
  
      User.new(user.first) # play is stored in an array!
    end
  
    def self.find_by_name(fname,lname)
      user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT
          *
        FROM
          users
        WHERE
          fname = ? AND lname = ?
      SQL
      return nil unless user.length > 0
  
      User.new(user.first)
    end
  
    def initialize(options)
      @id = options['id']
      @fname = options['fname']
      @lname = options['lname']
    end
  
    def create
      raise "#{self} already in database" if self.id
      QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
        INSERT INTO
          users (fname, lname)
        VALUES
          (?, ?, ?)
      SQL
      self.id = QuestionsDatabase.instance.last_insert_row_id
    end
  
    def update
      raise "#{self} not in database" unless self.id
      QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
        UPDATE
          users
        SET
          fname = ?, lname = ?
        WHERE
          id = ?
      SQL
    end
end


class Question
    attr_accessor :id, :title, :body, :author_id
  
    def self.all
      data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
      data.map { |datum| Questions.new(datum) }
    end
  
    def self.find_by_id(id)
      question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
          *
        FROM
          questions
        WHERE
          id = ?
      SQL
      return nil unless question.length > 0
  
      Question.new(question.first) # play is stored in an array!
    end
  
    def self.find_by_title(title)
      question = QuestionsDatabase.instance.execute(<<-SQL, title)
        SELECT
          *
        FROM
          questions
        WHERE
          title = ?
      SQL
      return nil unless question.length > 0
  
      User.new(question.first)
    end
  
    def self.find_by_body(body)
        question = QuestionsDatabase.instance.execute(<<-SQL, body)
          SELECT
            *
          FROM
            questions
          WHERE
            body = ?
        SQL
        return nil unless question.length > 0
    
        User.new(question.first)
    end

    def self.find_by_author(author_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
          SELECT
            *
          FROM
            questions
          WHERE
            author_id = ?
        SQL
        return nil unless question.length > 0
    
        User.new(question.first)
    end

    def initialize(options)
      @id = options['id']
      @title = options['title']
      @body = options['body']
      @author_id = options['author_id']
    end
  
    def create
      raise "#{self} already in database" if self.id
      QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author_id)
        INSERT INTO
          questions (title, body, author_id)
        VALUES
          (?, ?, ?, ?)
      SQL
      self.id = QuestionsDatabase.instance.last_insert_row_id
    end
  
    def update
      raise "#{self} not in database" unless self.id
      QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author_id, self.id)
        UPDATE
          questions
        SET
          title = ?, body = ?, author_id = ?
        WHERE
          id = ?
      SQL
    end
end