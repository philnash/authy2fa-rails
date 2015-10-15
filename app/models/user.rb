require "net/http"
require "uri"

class User < ActiveRecord::Base
  has_secure_password

  enum authy_status: [:unverified, :onetouch, :sms, :token, :approved, :denied]
  validates :email,  presence: true, format: { with: /\A.+@.+$\Z/ }, uniqueness: true
  validates :name, presence: true
  validates :country_code, presence: true
  validates :phone_number, presence: true

  def send_one_touch
    response = Authy::OneTouch.send_approval_request(
      id: self.authy_id,
      message: "Request to Login to Twilio demo app",
      details: {
        'Email Address' => self.email,
        'Amount' => '10 BTC',
      }
    )
    puts response.body
    set_status_and_uid(response.body)

    return response.body
  end

  private

  def set_status_and_uid(response)
    response = JSON.parse(response)

    status = response[:approval_request] ? :onetouch : :sms
    self.update(authy_status: status)
  end
end
