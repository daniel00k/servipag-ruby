require "servipag/version"
require "base64"
require "openssl"
require 'validator'
require 'servipag_configuration'
require 'generator_helper'
require 'crypt_decrypt'
require 'parser'
require 'rest_client'

module Servipag

  include ServipagConfiguration
  include Validator
  include CryptDecrypt
  module ApiRequests
  	class TransactionBegginer < ServipagConfiguration::Configuration
      attr_accessor :eps, 
                    :payment_channel_id, 
                    :id_tx_client, 
                    :payment_date, 
                    :total_amount, 
                    :bill_counter, 
                    :id_sub_trx, 
                    :identifier_code, 
                    :bill, 
                    :amount, 
                    :expiration_date
      
  		def initialize(attrs={})
        super unless defined? @@settings
        @payment_channel_id =  @@settings['payment_channel_id']
        @id_tx_client       =  GeneratorHelper::TokenGenerator.generate_token
        @payment_date       =  GeneratorHelper::DateGenerator.generate_payment_date
        @total_amount       =  Validator.validate_total_amount_length(attrs[:total_amount])
        @bill_counter       =  attrs[:bill_counter].to_i > 0 ? attrs[:bill_counter].to_i : 1
        @id_sub_trx         =  attrs[:id_sub_trx].to_i   > 0 ? attrs[:id_sub_trx].to_i   : 1
        @identifier_code    =  GeneratorHelper::TokenGenerator.generate_numeric_token
        @bill               =  GeneratorHelper::TokenGenerator.generate_numeric_random_token
        @amount             =  @total_amount
        @expiration_date    =  GeneratorHelper::DateGenerator.generate_payment_date  
        @eps                =  CryptDecrypt::Encrypt.encrypt_using_public_key(@@settings['public_key_path'], concatenated_strings).gsub("\n",'')
      end

      def create_request
        RestClient.post(@@settings['servipag_url'], 
                        GeneratorHelper::XML::Xml1.generate_xml(attrs_hash), 
                        content_type: :xml)
      end
      
      def servipag_url
        settings['servipag_url']
      end

      def concatenated_strings
        [ @payment_channel_id,
            @id_tx_client,
            @payment_date,
            @total_amount,
            @bill_counter,
            @id_sub_trx,
            @identifier_code,
            @bill_counter,
            @amount,
            @expiration_date,
           ].join('')
      end

      def attrs_hash
        {
          payment_channel_id: @payment_channel_id,
          id_tx_client:       @id_tx_client,
          payment_date:       @payment_date,
          total_amount:       @total_amount,
          bill_counter:       @bill_counter,
          id_sub_trx:         @id_sub_trx,
          identifier_code:    @identifier_code,
          bill:               @bill,
          amount:             @amount,
          expiration_date:    @expiration_date,
          eps:                @eps
        }
      end
  	end

  	class PurchaseConfirmation < ServipagConfiguration::Configuration
      attr_accessor :return_code, :message
      
      def initialize attrs={}
        super unless defined? @@settings
        @return_code = attrs[:return_code]
        @message     = attrs[:message]
      end

      def write_xml
        GeneratorHelper::XML::Xml3.generate_xml return_code: @return_code, message: @message
      end

  	end
  end

  module ApiResponse
  	class PaymentConfirmation < ServipagConfiguration::Configuration
      attr_accessor :servipag_signature, :servipag_id_trx,
                    :id_tx_client,       :payment_date,
                    :payment_method_id,  :accountable_date,
                    :identifier_code,    :bill,
                    :amount
      
      def initialize xml
        super unless defined? @@settings
        attrs = Parser.parse_xml2 xml
        attrs.each{|k,v| send("#{k}=", v)}
      end

      def is_xml2_valid?      
        Validator::Xml2.validate_signature self, settings['private_key_path']
      end

      def show_response_when_positive_status message
        ApiRequest::PurchaseConfirmation.new return_code: 1, message: message
      end

      def show_response_when_negative_status message
        ApiRequest::PurchaseConfirmation.new return_code: 0, message: message
      end
  		
  	end

  	class CompleteTransaction < ServipagConfiguration::Configuration
      attr_accessor :servipag_signature, :servipag_id_trx,
                    :id_tx_client,       :payment_state,
                    :message
      def initialize xml
        super unless defined? @@settings
        attrs = Parser.parse_xml4 xml
        attrs.each{|k,v| send("#{k}=", v) }
      end
  		
      def is_xml4_valid?
        Validator::Xml4.validate_signature self, settings['private_key_path']
      end

  	end
  end
end