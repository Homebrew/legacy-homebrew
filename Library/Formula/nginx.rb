require 'brewkit'

class Nginx < Formula
  @url='http://sysoev.ru/nginx/nginx-0.7.62.tar.gz'
  @homepage='http://nginx.net/'
  @md5='ab22f1b7f098a90d803a3abb94d23f7e'

  depends_on 'pcre'
  
  def options
    [
      ['--with-passenger', "Compile with support for Phusion Passenger module"]
    ]
  end
    
  def install
    configure_args = [
      "--prefix=#{prefix}",
      "--with-http_ssl_module"
    ]
    
    if ARGV.include? '--with-passenger'
      passenger_root = `passenger-config --root`.chomp
      
      if File.directory?(passenger_root)
        configure_args << "--add-module=#{passenger_root}/ext/nginx"
      else
        puts "Unable to install nginx with passenger support. The passenger"
        puts "gem must be installed and passenger-config must be in your path"
        puts "in order to continue."
        exit
      end
    end
    
    system "./configure", *configure_args
    system "make install"
  end 
end
