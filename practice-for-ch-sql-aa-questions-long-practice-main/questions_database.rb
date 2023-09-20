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
      return nil unless play.length > 0
  
      User.new(play.first) # play is stored in an array!
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
      return nil unless play.length > 0
  
      User.new(play.first)
    end
  
    def initialize(options)
      @id = options['id']
      @fname = options['fname']
      @lname = options['lname']
    end
  
    def create
      raise "#{self} already in database" if self.id
      PlayDBConnection.instance.execute(<<-SQL, self.fname, self.lname)
        INSERT INTO
          users (fname, lname)
        VALUES
          (?, ?, ?)
      SQL
      self.id = PlayDBConnection.instance.last_insert_row_id
    end
  
    def update
      raise "#{self} not in database" unless self.id
      PlayDBConnection.instance.execute(<<-SQL, self.fname, self.lname, self.id)
        UPDATE
          users
        SET
          fname = ?, lname = ?
        WHERE
          id = ?
      SQL
    end
  end