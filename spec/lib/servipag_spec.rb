require "spec_helper"

describe Servipag do
	describe GeneratorHelper::TokenGenerator do
		it "should generate a alfanumerical token" do
			GeneratorHelper::TokenGenerator.generate_token.should be_instance_of String
			GeneratorHelper::TokenGenerator.generate_token.split('').size.should <= 22
		end
		it "should generate a numerical token" do
			GeneratorHelper::TokenGenerator.generate_numeric_token.should be_instance_of Fixnum
		end

		it "should generate a numerical token of size less than 21" do
			GeneratorHelper::TokenGenerator.generate_numeric_random_token.to_s.split('').size.should <= 21
		end
	end
	describe GeneratorHelper::DateGenerator do
		it "should generate today's date on a propper format" do 
			GeneratorHelper::DateGenerator.generate_payment_date.should be_instance_of String
			GeneratorHelper::DateGenerator.generate_payment_date.to_s.split('').size.should eq(8)
		end
	end
	describe ServipagConfiguration do
		it "should read the yaml file like a boss" do 
			@conf  =  ServipagConfiguration::Configuration.new("test", File.expand_path("..",__FILE__))
			@conf.settings['payment_channel_id'].should eq(544)
			@conf.settings['private_key_path'].should eq("/Users/danielaguilar/Documents/acid/servipag/servipag/spec/lib/rsa/private.key")
			@conf.settings['public_key_path'].should eq("/Users/danielaguilar/Documents/acid/servipag/servipag/spec/lib/rsa/public.key")
		end
	end
	describe Servipag::ApiRequests::TransactionBegginer do
		it "should be able to create a transaction begginer object" do
			@conf  =  ServipagConfiguration::Configuration.new("test", File.expand_path("..",__FILE__))
			@tb    =  Servipag::ApiRequests::TransactionBegginer.new total_amount: 3000
			@tb.class.to_s.should eq(Servipag::ApiRequests::TransactionBegginer.to_s)
		end

		it "should send a xml archive to a servipag server" do 
			@conf  =  ServipagConfiguration::Configuration.new("test", File.expand_path("..",__FILE__))
			@tb    =  Servipag::ApiRequests::TransactionBegginer.new total_amount: 1,
																	 id_tx_client: '1370291429uanwxinofge',
																	 payment_date: '20130603',
																	 identifier_code: '1370291429',
																	 bill: '13702914291467263938',
																	 expiration_date: '20130603'
			@tb.concatenated_strings.should eq('5441370291429uanwxinofge20130603111137029142913702914291467263938120130603')
			@tb.eps.should eq('YKKXRAZ1jlbE4wXvyEs6T+0LlL/YsK3kT+a/TJHVCQgwScJV6Wk0nk1FBlQw4HyuaWkNs6wL7qY09bVYc553C2oVggMKxV2uQ5LRr8lzDAHYwFtWDXSgXjxQGF8JRX5IoCimVNtqQsK7SaNDMS5Bf8O6DLurtCU2KsjeKveDp1A=')
		end

		describe Servipag::ApiResponse::PaymentConfirmation do
			it "should create a payment confirmation object" do
				@xml  =  File.open(File.expand_path("../xml/example_xml2.xml", __FILE__))
				@pc   =  Servipag::ApiResponse::PaymentConfirmation.new @xml
				@pc.class.to_s.should eq(Servipag::ApiResponse::PaymentConfirmation.to_s)
				@pc.is_xml2_valid?.should be_true
				@pc.amount.should eq(3000)
			end
		end

		describe Servipag::ApiResponse::CompleteTransaction do
			it "should read the xml4 and create an Servipag::ApiResponse::CompleteTransaction object" do
				@xml  =  File.open(File.expand_path("../xml/example_xml4.xml", __FILE__))
				@ct   =  Servipag::ApiResponse::CompleteTransaction.new @xml
				@ct.class.to_s.should eq(Servipag::ApiResponse::CompleteTransaction.to_s)
				@ct.is_xml4_valid?.should be_true
			end
		end
		describe Servipag::ApiRequests::PurchaseConfirmation do
			it "should write the xml3 response" do
				@xml = Servipag::ApiRequests::PurchaseConfirmation.new(message: "Bien brother", return_code: true).write_xml
				@xml.to_s.gsub("\n",'').gsub("\t",'').should eq("<?xml version=\"1.0\"?><Servipag>  <CodigoRetorno>true</CodigoRetorno>  <MensajeRetorno>Bien brother</MensajeRetorno></Servipag>".to_s)
			end
		end
	end
end