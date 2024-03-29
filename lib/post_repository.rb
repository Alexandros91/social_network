require_relative './post'

class PostRepository

  def all
    sql = 'SELECT id, title, content, views, account_id FROM posts;'

    result_set = DatabaseConnection.exec_params(sql, [])

    posts = []

    result_set.each do |record|
      post = Post.new
      post.id = record['id'].to_i
      post.title = record['title']
      post.content = record['content']
      post.views = record['views'].to_i
      post.account_id = record['account_id'].to_i

      posts << post
    end

    return posts
  end


  def find(id)
    sql = 'SELECT id, title, content, views, account_id FROM posts
    WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)
    record = result_set[0]

    post = Post.new
    post.id = record['id'].to_i
    post.title = record['title']
    post.content = record['content']
    post.views = record['views'].to_i
    post.account_id = record['account_id'].to_i

    return post
  end

  def create(post)
    sql = 'INSERT INTO posts (title, content, views, account_id) VALUES
          ($1, $2, $3, $4);'
    sql_params = [post.title, post.content, post.views, post.account_id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1;'
    sql_params = [id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def update(post)
    sql = 'UPDATE posts SET title = $1, content = $2, views = $3, account_id = $4;'
    sql_params = [post.title, post.content, post.views, post.account_id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end
end