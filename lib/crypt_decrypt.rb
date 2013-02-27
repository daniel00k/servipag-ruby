module CryptDecrypt
	module KeyFinder
		def self.find_and_read_key key_path
			OpenSSL::PKey::RSA.new(File.open(key_path).read)
		end
	end
	class Encrypt
		# key_path debe ser absoluta
		def self.encrypt_using_public_key key_path, string
			public_key       = CryptDecrypt::KeyFinder.find_and_read_key key_path
			encrypted_string = Base64.encode64(public_key.public_encrypt(string))
		end
	end

	class Decrypt
		def self.decrypt_using_private_key key_path, string
			private_key       = CryptDecrypt::KeyFinder.find_and_read_key key_path
			private_key.private_decrypt(Base64.decode64(string))
		end
	end
end