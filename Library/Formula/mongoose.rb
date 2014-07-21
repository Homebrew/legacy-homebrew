require 'formula'

class Mongoose < Formula
  homepage 'https://github.com/valenok/mongoose'
  url 'https://github.com/valenok/mongoose/archive/5.1.tar.gz'
  sha1 '0a2d0b83a7f5650a6e6c50fd7ba18a06ebe79335'

  def install
    cd 'build' do
      system 'make all'
      bin.install "mongoose"
    end
    include.install 'mongoose.h'
    prefix.install 'examples', 'docs'
  end
end
