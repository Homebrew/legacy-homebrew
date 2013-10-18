require 'formula'

class MongoC < Formula
  homepage 'http://docs.mongodb.org/ecosystem/drivers/c/'
  url 'https://github.com/mongodb/mongo-c-driver/archive/v0.8.1.zip'
  sha1 '38ae6a6273bbf11e24f696a65a3ea3901e456126'

  def install
    system "make"
    system "make", "install", "DESTDIR=", "PREFIX=#{prefix}"
  end
end
