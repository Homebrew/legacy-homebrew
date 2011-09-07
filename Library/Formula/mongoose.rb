require 'formula'

class Mongoose < Formula
  url 'http://mongoose.googlecode.com/files/mongoose-2.11.tgz'
  homepage 'http://code.google.com/p/mongoose/'
  md5 'f6985da7513d354cc18b21b7670d23c1'

  def install
    system "/usr/bin/make mac"
    bin.install "mongoose"
    man1.install "mongoose.1"
  end
end
