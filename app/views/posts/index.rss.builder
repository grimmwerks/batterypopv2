xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @feed_title
    xml.description @blog_description
    xml.link posts_url
    
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.body.html_safe
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link  post_url(post)
        xml.guid post_url(post)
      end
    end
  end
end