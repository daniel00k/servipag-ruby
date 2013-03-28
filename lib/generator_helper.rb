module GeneratorHelper
	class TokenGenerator
		def self.generate_token
			"#{Time.now.to_i}#{self.generate_random_token(('a'..'z'),('A'..'Z'))}"
		end

		def self.generate_numeric_token
			Time.now.to_i
		end

		def self.generate_numeric_random_token
			"#{Time.now.to_i}#{self.generate_random_token((1..10),(100..1000))}".slice(0,20).to_i
		end
		
		def self.generate_random_token range_one, range_two
			o     = [range_one,range_two].map{|i| i.to_a}.flatten
	    	token = (0..10).map{ o[rand(o.length)]  }.join
		end
	end
	class DateGenerator
		def self.generate_payment_date
			Time.now.strftime("%Y%m%d")
		end
	end	
	module XML
		class Xml1
			def self.generate_xml attrs={}
				"<Servipag>
					<Header>
						<FirmaEPS>#{attrs[:eps].gsub!("\n",'').gsub!("\t",'').downcase}</FirmaEPS>
						<CodigoCanalPago>#{attrs[:payment_channel_id]}</CodigoCanalPago>
						<IdTxCliente>#{attrs[:id_tx_client].downcase}</IdTxCliente>
						<FechaPago>#{attrs[:payment_date].downcase}</FechaPago>
						<MontoTotalDeuda>#{attrs[:total_amount]}</MontoTotalDeuda>
						<NumeroBoletas>#{attrs[:bill_counter]}</NumeroBoletas>
					</Header> 
					<Documentos>
						<IdSubTrx>#{attrs[:id_sub_trx]}</IdSubTrx>
						<CodigoIdentificador>#{attrs[:identifier_code]}</CodigoIdentificador>
						<Boleta>#{attrs[:bill]}</Boleta>
						<Monto>#{attrs[:amount]}</Monto>
						<FechaVencimiento>#{attrs[:expiration_date]}</FechaVencimiento>
					</Documentos>
				</Servipag>"
			end
		end
		class Xml3
			def self.generate_xml attrs={}
				"<?xml version='1.0' encoding='ISO8859-1'?>
				<Servipag>
					<CodigoRetorno>#{attrs[:return_code]}</CodigoRetorno>
					<MensajeRetorno>#{attrs[:message]}</MensajeRetorno>
				</Servipag>"
			end
		end
	end
end
