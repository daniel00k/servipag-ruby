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
				builder = Nokogiri::XML::Builder.new do |xml|
					xml.Servipag {
						xml.Header {
							xml.FirmaEPS        attrs[:eps].gsub("\n",'').gsub("\t",'').downcase
							xml.CodigoCanalPago attrs[:payment_channel_id]
							xml.IdTxCliente     attrs[:id_tx_client].downcase
							xml.FechaPago       attrs[:payment_date].downcase
							xml.MontoTotalDeuda attrs[:total_amount]
							xml.NumeroBoletas   attrs[:bill_counter]
						}
						xml.Documentos{
							xml.IdSubTrx             attrs[:id_sub_trx]
							xml.CodigoIdentificador  attrs[:identifier_code]
							xml.Boleta               attrs[:bill]
							xml.Monto                attrs[:amount]
							xml.FechaVencimiento     attrs[:expiration_date]
						}
					}
				end
				builder.to_xml
			end
		end
		class Xml3
			def self.generate_xml attrs={}
				builder = Nokogiri::XML::Builder.new do |xml|
					xml.Servipag {
							xml.CodigoRetorno   attrs[:return_code]
							xml.MensajeRetorno  attrs[:message]
					}
				end
				builder.to_xml
			end
		end
	end
end
