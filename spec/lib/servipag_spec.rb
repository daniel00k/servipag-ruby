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
			@conf.settings['payment_channel_id'].should eq(123)
			@conf.settings['private_key_path'].should eq("../rsa/private.key")
			@conf.settings['public_key_path'].should eq("../rsa/public.key")
		end
	end
end