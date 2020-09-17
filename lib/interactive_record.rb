require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
    def self.table_name
        self.to_s.downcase.pluralize
    end



    def self.column_names
        DB[:conn].results_as_hash = true
    
        sql = "pragma table_info('#{self.table_name}')"
    
        table_info = DB[:conn].execute(sql)
        column_names = []
        table_info.each do |row|
          column_names << row["name"]
        end
        column_names.compact
    end
    



    def initialize(attributes={})
        attributes.each do |property, value|
            self.send("#{property}=", value)
        end
    end
  





    def table_name_for_insert
    # return the table name when called on an instance of Student (FAILED - 5)
    self.class.table_name
    end



    def col_names_for_insert
        self.class.column_names.delete_if{|col| col == "id"}.join(", ")
        #return the column names when called on an instance of Student (FAILED - 6)
        #does not include an id column (FAILED - 7)
    end



    def values_for_insert
        values = []
        self.class.column_names.each do |col|
            values << "'#{send(col)}'" unless send(col).nil?
        end
        values.join(", ")

    # formats the column names to be used in a SQL statement (FAILED - 8)
    end



    def save
        sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
        DB[:conn].execute(sql)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
        
       
    end



    def self.find_by_name(name)
    # executes the SQL to find a row by name (FAILED - 11)
    sql = "SELECT * FROM '#{self.table_name}' WHERE name = '#{name}'"
    DB[:conn].execute(sql)
    end

    def self.find_by(row)
        # DB[:conn].results_as_hash = true

        row_key = row.keys.first
        row_value = row.values.first


        sql = "SELECT * FROM '#{self.table_name}' WHERE #{row_key} = '#{row_value}'" # DOES THE SQL KNOW HOW TO TREAT ROW_KEY
        DB[:conn].execute(sql)

    end




end