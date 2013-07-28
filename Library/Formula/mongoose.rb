require 'formula'

class Mongoose < Formula
  homepage 'https://github.com/valenok/mongoose'
  url 'https://github.com/valenok/mongoose/archive/3.8.tar.gz'
  sha1 '52b1f31132c4212628a4be9507f7f1891c3ee9da'

  def install
    system 'make mac'
    bin.install "mongoose"
    include.install 'mongoose.h'
    prefix.install 'examples', 'UserManual.md'
  end
end
