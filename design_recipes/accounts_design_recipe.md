# Account Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `accounts`*

```
# EXAMPLE

Table: accounts

Columns:
id | email | username
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: seeds/accounts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE accounts RESTART IDENTITY; -- replace with your own table email.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO accounts (email, username) VALUES ('first_email@test.com', 'user_1_test');
INSERT INTO accounts (email, username) VALUES ('second_email@test.com', 'user_2_test');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < accounts.sql
```

## 3. Define the class emails

Usually, the Model class email will be the capitalised table email (single instead of plural). The same email is then suffixed by `Repository` for the Repository class email.

```ruby
# EXAMPLE
# Table email: accounts

# Model class
# (in lib/account.rb)
class Account
end

# Repository class
# (in lib/account_repository.rb)
class AccountRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table title: accounts

# Model class
# (in lib/account.rb)

class Account

  # Replace the attributes by your own columns.
  attr_accessor :id, :email, :username
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# account = Account.new
# account.email = 'Jo'
# account.email
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table title: accounts

# Repository class
# (in lib/account_repository.rb)

class AccountRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, email, username, artist_id FROM accounts;

    # Returns an array of account objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, email, username FROM accounts WHERE id = $1;

    # Returns a single account object.
  end

  # Add more methods below for each operation you'd like to implement.

    # Inserts a new account record
    # Takes an account object as an argument
  def create(account)
    # Executes the SQL query:
    # INSERT INTO accounts (email, username) VALUES ($1, $2);

    # Returns nothing (only creates the account record)
  end

  # def update(account)
  # end

  # def delete(account)
  # end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all accounts

repo = AccountRepository.new

accounts = repo.all
accounts.length # =>  2

accounts[0].id # =>  1
accounts[0].email # =>  'first_email@test.com'
accounts[0].username # => 'user_1_test' 

accounts[1].id # =>  2
accounts[1].email # =>  'second_email@test.com'
accounts[1].username # =>  'user_2_test'


# 2
# Get a single account

repo = accountRepository.new

account = repo.find(1)

account.id # =>  1
accounts.email # =>  'first_email@test.com'
accounts.username # => 'user_1_test' 

# 3
# Get another account

repo = accountRepository.new

account = repo.find(2)

account.id # =>  2
accounts.email # =>  'second_email@test.com'
accounts.username # => 'user_2_test' 

# Add more examples for each method

# 6
# Create a new account

repo = AccountRepository.new
accounts = repo.all

account = Account.new
account.email = 'third_email@test.com'
account.username = 'user_3_test'

repo.create(account)

accounts.length # => 3
accounts.last.id # => 3
accounts.last.email # => 'third_email@test.com'
accounts.last.username # => 'user_3_test'

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/account_repository_spec.rb

def reset_accounts_table
  seed_sql = File.read('seeds/accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe accountRepository do
  before(:each) do 
    reset_accounts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->