require 'nokogiri'
class Parser
	def self.parse_xml2 xml
		doc   = Nokogiri::XML xml
		hash  = {}
		%w( FirmaServipag 
			IdTrxServipag 
			IdTxCliente 
			FechaPago 
			CodMedioPago 
			FechaContable 
			CodigoIdentificador 
			Boleta 
			Monto).each do |tag|
				if Validator.is_a_number?(doc.xpath("//#{tag}").first.children.first.content.strip)
					hash[Validator::Xml2.translate_from_xml(tag).to_s] =  doc.xpath("//#{tag}").first.children.first.content.strip.to_i
				else
					hash[Validator::Xml2.translate_from_xml(tag).to_s] =  doc.xpath("//#{tag}").first.children.first.content.strip
				end
			end
		hash
	end
	
	def self.parse_xml4 xml
		doc   = Nokogiri::XML xml
		hash  = {}
		%w( FirmaServipag 
			IdTrxServipag 
			IdTxCliente 
			EstadoPago
			Mensaje).each do |tag|
				hash[Validator::Xml2.translate_from_xml(tag).to_s] = doc.xpath("//#{tag}").first.children.first.content.strip
			end
		hash
	end
end