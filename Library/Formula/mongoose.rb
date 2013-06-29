require 'formula'

class Mongoose < Formula
  homepage 'https://github.com/valenok/mongoose'
  url 'https://github.com/valenok/mongoose/archive/3.7.tar.gz'
  sha1 'ca9425456c11fc795515f6987396a5945bf788cd'

  def install
    system 'make mac'
    bin.install "mongoose"
    include.install 'mongoose.h'
    prefix.install 'examples', 'UserManual.md'
  end
end
