class User < ApplicationRecord
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => ENV['OTP_SECRET_KEY'] || SecureRandom.hex(16)

     
       # Include default devise modules. Others available are:
       # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
       devise :registerable,
              :recoverable, :rememberable, :validatable
     
       devise :two_factor_backupable,
              otp_backup_code_length: 8,
              otp_number_of_backup_codes: 12
       
       serialize :otp_backup_codes, JSON
       attr_accessor :otp_plain_backup_codes

       def generate_two_factor_secret_if_missing!
              return unless otp_secret.nil?
              update!(otp_secret: User.generate_otp_secret)
            end
          
       def otp_qrcode
       provision_uri = otp_provisioning_uri(email, issuer: '2FA-Demo')
       RQRCode::QRCode.new(provision_uri)
       end
     end