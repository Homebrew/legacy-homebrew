require 'formula'

class MongoC < Formula
  homepage 'http://docs.mongodb.org/ecosystem/drivers/c/'
  url 'https://s3.amazonaws.com/drivers.mongodb.org/c/mongo-c-driver-0.7.1.zip'
  sha1 '4409af06513102c269e327c4a34f5121b244f61a'

  def install
    system "make"
    system "make install DESTDIR='' PREFIX=#{prefix}"
  end
end
