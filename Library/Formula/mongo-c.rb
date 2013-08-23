require 'formula'

class MongoC < Formula
  homepage 'http://docs.mongodb.org/ecosystem/drivers/c/'
  url 'https://github.com/mongodb/mongo-c-driver/zipball/v0.8'
  sha1 'af602a051af7ae4fad32e6d98fb62bd331cd5465'

  def install
    system "make"
    system "make install DESTDIR='' PREFIX=#{prefix}"
  end
end
