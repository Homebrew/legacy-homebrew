module Utils
  module HTMLConvert
    def html_anchor_to_markdown!(string, host)
      link = /(<a.*?>)(.*?)(<\/a>)/
      link_url = /(href=")(.*?)(")/
      link_text = /(>)(.*?)(<)/
      uri_scheme = /^[a-zA-Z][a-zA-Z0-9\+\-\.]*:/
      string.gsub!(link) {|anchor|
        url = anchor.scan(link_url)[0][1]
        text = anchor.scan(link_text)[0][1]
        unless url.match(uri_scheme)
          if url.start_with?('/')
            url.prepend(host)
          else
            url.prepend(host.chomp('/')+'/')
          end
        end
        anchor.gsub!(link, '['+text+']'+'('+url+')')
      }
    end
    
    def convert_html_tags!(string)
      # bold = /(<b.*?>)(.*?)(<\/b>)/
      # TODO: convert bold tags to Terminal codes for opening and closing bold text respectively
      # TODO: convert color tags to Terminal codes for respective colors
      # TODO: remove all other HTML tags
      html_anchor_to_markdown! string
    end
  end
end