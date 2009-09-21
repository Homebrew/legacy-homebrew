require 'brewkit'

class Nginx <Formula
  @url='http://sysoev.ru/nginx/nginx-0.7.61.tar.gz'
  @homepage='http://nginx.net/'
  @md5='6ebf89b9b00a3b82734e93c32da7df07'

  depends_on 'pcre'
    
  def install
    system "./configure", "--prefix=#{prefix}", "--with-http_ssl_module"
    system "make install"
  end 
end
