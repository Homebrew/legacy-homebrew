require 'formula'

class Mongoose < Formula
  homepage 'https://github.com/valenok/mongoose'
  url 'https://github.com/valenok/mongoose/archive/4.1.tar.gz'
  sha1 'e9c25fec4e1b9b929101201beacb9c5ba51ad78c'

  def install
    cd 'build' do
      system 'make mac'
      bin.install "mongoose"
    end
    include.install 'mongoose.h'
    prefix.install 'examples', 'UserManual.md'
  end
end
