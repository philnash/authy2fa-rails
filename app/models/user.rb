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
    uri = URI.parse("#{Authy.api_uri}/onetouch/json/users/#{self.authy_id}/approval_requests")
    
    response = Net::HTTP.post_form(uri,{
      "api_key" => Authy.api_key,
      "message" => "Request to Login to Twilio demo app",
      "details[Email]" => self.email,
      "logos[][res]" => "default",
      "logos[][url]" => "http://howtodocs.s3.amazonaws.com/twilio-logo.png"
    })

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
