require 'formula'

class Mongoose < Formula
  homepage 'https://github.com/valenok/mongoose'
  url 'https://github.com/valenok/mongoose/tarball/3.2'
  sha1 'c825fad84061e497d1d2fb711b94c6fdf5c1398c'

  def install
    system "make", "mac", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "mongoose"
    man1.install "mongoose.1"
  end
end