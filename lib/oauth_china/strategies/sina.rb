# -*- coding: utf-8 -*-
module OauthChina
  class Sina < OauthChina::OAuth
      
    def initialize(*args)
      self.consumer_options = {
        :site               => 'http://api.t.sina.com.cn',
        :request_token_path => '/oauth/request_token',
        :access_token_path  => '/oauth/access_token',
        :authorize_path     => '/oauth/authorize',
        :realm              => url
      }
      super(*args)
    end

    def name
      :sina
    end

    def authorized?
      #TODO
    end

    def destroy
      #TODO
    end 
    
    def add_status(content, options = {})
      options.merge!(:status => content)
      self.post("http://api.t.sina.com.cn/statuses/update.json", options)
    end

    def comment(content, id, options = {})
      options.merge!(:comment => content, :id => id)
      self.post("http://api.t.sina.com.cn/statuses/comment.json", options)
    end

    def friends(id, cursor = -1)  
      body = self.get("http://api.t.sina.com.cn/statuses/friends/#{id}.json?cursor=#{cursor}&count=200").body
      
    end
    
    def user_info(id)  
      body = self.get("http://api.t.sina.com.cn/users/show/#{id}.json").body 
    end

    def user_timeline(id, since_id = 0)  
      body = self.get("http://api.t.sina.com.cn/statuses/user_timeline.json?user_id=#{id}&since_id=#{since_id}").body 
    end

    def comments(id, count = 200)  
      body = self.get("http://api.t.sina.com.cn/statuses/comments.json?id=#{id}&count=#{count}").body 
    end
    
    def friends_v2(uid, cursor = -1)  
      body = self.get("http://api.weibo.com/2/friendships/friends.json?uid=#{uid}&cursor=#{cursor}&count=200").body
      
    end
    
    def bilateral_ids(uid, page, api_key)  
      body = self.get("http://api.weibo.com/2/friendships/friends.json?source=#{api_key}uid=#{uid}&page=#{page}&count=2000").body
      
    end
    
    def followers(id, cursor = -1)  
      body = self.get("http://api.t.sina.com.cn/statuses/followers/#{id}.json?cursor=#{cursor}&count=200").body
      
    end
    
    def follow(id)  
      self.post("http://api.t.sina.com.cn/friendships/create/#{id}.json")
    end
    
    def friendships(source_id, target_id)  
      body = self.get("http://api.t.sina.com.cn/friendships/show.json?source_id=#{source_id}&target_id=#{target_id}").body
      
    end
    
    def short_url(long_urls, api_key = nil)  
      long_urls_query = long_urls.to_a.map do |url|
        "url_long=#{CGI.escape(url)}"
      end.join("&")
      url = "http://api.t.sina.com.cn/short_url/shorten.json?#{long_urls_query}"
      url = "#{url}&source=#{api_key}" if api_key 
      body = self.get(url).body
    end
    
    def friendships_destroy(user_id)  
      body = self.post("http://api.t.sina.com.cn/friendships/destroy/#{user_id}.json").body
    end 
    
    def upload_image(content, image_path, options = {})
      options = options.merge!(:status => content, :pic => File.open(image_path, "rb")).to_options
      upload("http://api.t.sina.com.cn/statuses/upload.json", options)
    end

    

  end
end