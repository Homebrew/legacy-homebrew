require 'formula'

class MongoC < Formula
  homepage 'http://docs.mongodb.org/ecosystem/drivers/c/'
  url 'https://github.com/mongodb/mongo-c-driver/archive/v0.8.zip'
  sha1 'af602a051af7ae4fad32e6d98fb62bd331cd5465'

  def patches
    # Fix to follow naming conventions
    "https://gist.github.com/planas/6321873/raw"
  end

  def install
    system "make"
    system "make install DESTDIR='' PREFIX=#{prefix}"
  end
end
