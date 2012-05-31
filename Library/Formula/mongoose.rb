require 'formula'

class Mongoose < Formula
  homepage 'http://code.google.com/p/mongoose/'
  url 'http://mongoose.googlecode.com/files/mongoose-3.1.tgz'
  md5 'e718fc287b4eb1bd523be3fa00942bb0'

  def install
    system "make", "mac", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "mongoose"
    man1.install "mongoose.1"
  end
end
