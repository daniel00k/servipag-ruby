module Validator
	# Validation methods
	class Xml2
		def self.validate_signature payment_confirmation, key_path
			payment_confirmation.settings['xml2_keys'].split(' ').map{|k| payment_confirmation.send(self.translate_from_xml(k))}.join() ==  CryptDecrypt::Decrypt.decrypt_using_private_key(key_path, payment_confirmation.servipag_signature)
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
			complete_transaction.settings['xml4_keys'].split('').map{|k| complete_transaction.send(Validator::Xml2.translate_from_xml(k))}.join('') ==  CryptDecrypt::Decrypt.decrypt_using_private_key( key_path, complete_transaction.servipag_signature)
		end
	end
end