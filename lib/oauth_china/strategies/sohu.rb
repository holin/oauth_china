# -*- coding: utf-8 -*-
module OauthChina
  class Sohu < OauthChina::OAuth

    def initialize(*args)
      # 
      self.consumer_options = {
        :site               => 'http://api.t.sohu.com',
        :scheme             => :header,
        :request_token_path => '/oauth/request_token',
        :access_token_path  => '/oauth/access_token',
        :authorize_path     => '/oauth/authorize'
      }
      super(*args)
    end

    def name
      :sohu
    end

    def authorized?
      #TODO
    end

    def destroy
      #TODO
    end

    def add_status(content, options = {})
      options.merge!(:status => content)
      self.post("http://api.t.sohu.com/statuses/update.json", options)
    end

    def upload_image(content, image_path, options = {})
      options = options.merge!(:status => content, :pic => File.open(image_path, "rb")).to_options
      upload("http://api.t.sohu.com/statuses/upload.json", options)
    end
    
  end
end