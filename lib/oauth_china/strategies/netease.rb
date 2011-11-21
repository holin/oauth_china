# -*- coding: utf-8 -*-
module OauthChina
  class Netease < OauthChina::OAuth

    def initialize(*args)
      #fuck 163
      # 
      self.consumer_options = {
        :site               => 'http://api.t.163.com',
        :request_token_path => '/oauth/request_token',
        :access_token_path  => '/oauth/access_token',
        :authorize_path     => '/oauth/authenticate',
        :realm              => url
      }
      super(*args)
    end

    def name
      :netease
    end

    def authorized?
      #TODO
    end

    def destroy
      #TODO
    end

    def add_status(content, options = {})
      options.merge!(:status => content)
      self.post("http://api.t.163.com/statuses/update.json", options)
    end 
    
    def upload_image(content, image_path, options = {})
      options = options.merge!(:pic => File.open(image_path, "rb")).to_options
      image_url = parse_image_url(just_upload_image(image_path))
      add_status("#{image_url} #{content}", options)
    end

    private

    def just_upload_image(image_path)
      upload("http://api.t.163.com/statuses/upload.json", :pic => File.open(image_path, "rb"))
    end

    def parse_image_url(resp)
      hash_body = JSON.parse(resp.body)
      if hash_body["error"]
        raise hash_body["error"]
      else
        hash_body["upload_image_url"]
      end
    end

  end
end