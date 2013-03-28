module Validator
	
	def self.validate_total_amount_length total_amount
		if (self.is_a_number? total_amount.to_s) 
			if (total_amount.to_s.split('').size > 0 and total_amount.to_s.split('').size < 8)
				total_amount
				else
					raise "#{total_amount} invalid length"
				end
		else
			raise "#{total_amount} Is not a valid number"
		end		
	end
	
	# validates if is a number, replace commas for dots
	# equals 0 means true
	def self.is_a_number? string
		(string.gsub(',','.') =~ /^[-+]?[0-9]*\.?[0-9]+$/) == 0
	end
	class Xml2
		def self.validate_signature payment_confirmation, key_path
			CryptDecrypt::Decrypt.decrypt_using_public_key(key_path, payment_confirmation.servipag_signature, payment_confirmation.settings['xml2_keys'].split(' ').map{|k| payment_confirmation.send(self.translate_from_xml(k))}.join())
		end

		def self.translate_from_xml tag
			tags = {'FirmaServipag'       => :servipag_signature, 
							'IdTrxServipag'       => :servipag_id_trx,
							'IdTxCliente'         => :id_tx_client,
							'FechaPago'           => :payment_date,
              'CodMedioPago'        => :payment_method_id,
              'FechaContable'       => :accountable_date,
              'CodigoIdentificador' => :identifier_code,    
              'Boleta'              => :bill,
              'Monto'               => :amount,
              'EstadoPago'          => :payment_state,
							'Mensaje'             => :message
            }
      tags[tag]
		end
	end
	class Xml4
		def self.validate_signature complete_transaction, key_path
			 CryptDecrypt::Decrypt.decrypt_using_public_key( key_path, complete_transaction.servipag_signature, complete_transaction.settings['xml4_keys'].split(' ').map{|k| complete_transaction.send(Validator::Xml2.translate_from_xml(k))}.join())
		end
	end
end