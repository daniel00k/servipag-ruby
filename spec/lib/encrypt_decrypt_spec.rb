require 'spec_helper'
describe CryptDecrypt::Encrypt do 
	before(:each) do
		@public_key_path  = File.expand_path("../rsa/public.key", __FILE__)
		@private_key_path = File.expand_path("../rsa/private.key", __FILE__)
		@string           = 'anita_lava_la_tina'
	end
	it "should encrypt and decrypt a string" do
		@encrypted_string = CryptDecrypt::Encrypt.encrypt_using_private_key(@private_key_path, @string)
		CryptDecrypt::Decrypt.decrypt_using_public_key(@public_key_path, @encrypted_string, @string).should be_true
	end
end