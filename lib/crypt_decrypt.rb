module CryptDecrypt
	module KeyFinder
		def self.find_and_read_key key_path
			OpenSSL::PKey::RSA.new(File.open(key_path).read)
		end

		def self.digest
			OpenSSL::Digest::MD5.new
		end
	end
	class Encrypt
		# key_path debe ser absoluta
		def self.encrypt_using_private_key key_path, string
			pkey             = CryptDecrypt::KeyFinder.find_and_read_key key_path
			encrypted_string = Base64.encode64(pkey.sign(CryptDecrypt::KeyFinder.digest,string))
		end
	end

	class Decrypt
		def self.decrypt_using_public_key key_path, encrypted_string, string
			pub_key          = CryptDecrypt::KeyFinder.find_and_read_key key_path
			pub_key.verify(CryptDecrypt::KeyFinder.digest, Base64.decode64(encrypted_string),string)
		end
	end
end