# -*- coding: utf-8 -*-
require 'rubygems'
require 'oauth'
require 'mime/types'
require 'net/http'
require 'cgi'
require 'json'
require 'active_support/core_ext'

require File.expand_path(File.join(File.dirname(__FILE__), "oauth_china/multipart"))
require File.expand_path(File.join(File.dirname(__FILE__), "oauth_china/upload"))

module OauthChina

  class OAuth

    include Upload

    CONFIG = {}

    attr_accessor  :request_token, :access_token, :consumer_options

    delegate :get, :post, :put, :delete, :to => :access_token

    def initialize(request_token = nil, request_token_secret = nil)
      if request_token && request_token_secret
        self.request_token = ::OAuth::RequestToken.new(consumer, request_token, request_token_secret)
      else
        self.request_token = consumer.get_request_token(:oauth_callback => self.callback)
      end
    end

    #
    def oauth_token
      request_token.params[:oauth_token]
    end

    def consumer
      @consumer ||= ::OAuth::Consumer.new(key, secret, consumer_options)
    end

    def self.load(data)
      oauth = self.new(data[:request_token], data[:request_token_secret])
      oauth.access_token = ::OAuth::AccessToken.new(oauth.consumer, data[:access_token], data[:access_token_secret]) if data[:access_token] && data[:access_token_secret]
      oauth
    end

    def dump
      {
        :request_token        => request_token.token,
        :request_token_secret => request_token.secret,
        :access_token         => access_token.nil? ? nil : access_token.token,
        :access_token_secret  => access_token.nil? ? nil : access_token.secret
      }
    end

    def key; config['key'];  end
    def secret; config['secret']; end
    def url; config['url']; end
    def callback; config["callback"]; end

    def config
      CONFIG[self.name] ||= lambda do
        require 'yaml'
        filename = "#{Rails.root}/config/oauth/#{self.name}.yml"
        file     = File.open(filename)
        yaml     = YAML.load(file)
        return yaml[Rails.env]
      end.call
    end

    def authorize_url
      @authorize_url ||= request_token.authorize_url(:oauth_callback => URI.encode(callback))
    end
    
    def authorize_url_with_callback(_callback)
      request_token.authorize_url(:oauth_callback => URI.encode(_callback))
    end

    # 
    def authorize(options = {})
      return unless self.access_token.nil?
      token = self.request_token.get_access_token(options)
      # puts "authorize(options = {})"
      #       puts token.params
      #       self.access_token ||= ::OAuth::AccessToken.new(consumer, token.token, token.secret)
      self.access_token = token
    end

  end


  autoload :Sina,           'oauth_china/strategies/sina'
  autoload :Douban,         'oauth_china/strategies/douban'
  autoload :Qq,             'oauth_china/strategies/qq'
  autoload :Sohu,           'oauth_china/strategies/sohu'
  autoload :Netease,        'oauth_china/strategies/netease'
end