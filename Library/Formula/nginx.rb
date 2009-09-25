require 'brewkit'

class Nginx < Formula
  @url='http://sysoev.ru/nginx/nginx-0.7.62.tar.gz'
  @homepage='http://nginx.net/'
  @md5='ab22f1b7f098a90d803a3abb94d23f7e'

  depends_on 'pcre'
    
  def install
    system "./configure", "--prefix=#{prefix}", "--with-http_ssl_module"
    system "make install"
  end 
end
