require 'brewkit'

class Nginx < Formula
  @url='http://sysoev.ru/nginx/nginx-0.7.2.tar.gz'
  @homepage='http://nginx.net/'
  @md5='5d63188601cdd01f507161edc419ba0e'

  depends_on 'pcre'
    
  def install
    system "./configure", "--prefix=#{prefix}", "--with-http_ssl_module"
    system "make install"
  end 
end
