require "net/http"
require "uri"

class User < ActiveRecord::Base
  has_secure_password

  enum authy_status: [:unverified, :onetouch, :sms, :token, :approved, :denied]
  validates :email,  presence: true, format: { with: /\A.+@.+$\Z/ }, uniqueness: true
  validates :name, presence: true
  validates :country_code, presence: true
  validates :phone_number, presence: true

  after_save :notify_authy_status_change

  def self.clean_sql(query)
    sanitize_sql(query)
  end

  def notify_authy_status_change
    if authy_status_changed?
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        execute_query(connection, ["NOTIFY user_?, ?", id, authy_status])
      end
    end
  end

  def on_authy_status_change
    ActiveRecord::Base.connection_pool.with_connection do |connection|
      begin
        execute_query(connection, ["LISTEN user_?", id])
        connection.raw_connection.wait_for_notify do |event, pid, status|
          yield status
        end
      ensure
        execute_query(connection, ["UNLISTEN user_?", id])
      end
    end
  end

  private

  def execute_query(connection, query)
    sql = self.class.clean_sql(query)
    connection.execute(sql)
  end
end
