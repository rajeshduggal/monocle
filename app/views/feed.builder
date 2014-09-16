xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title settings.website_name
    xml.description settings.website_description
    xml.link "#{request.base_url}/"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link post.url

        xml.description(%{
          #{post.summary}
          <p>
            <a href="#{post.url}">Read more</a> |
            <a href="#{request.base_url + post.slug_fullpath}">Comments</a>
          </p>
        })

        xml.pubDate post.published_at.rfc822
        xml.guid post.slug
      end
    end
  end
end
