require 'formula'

class Hiredis < Formula
  url 'https://github.com/antirez/hiredis/tarball/v0.10.0'
  head 'https://github.com/antirez/hiredis.git'
  homepage 'https://github.com/antirez/hiredis'
  version '0.10.0'
  sha1 'a54dd2b31cb39bc05bf88538c688bf50f8c6c9c7'

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    system "make PREFIX=#{prefix}"
    system "make install PREFIX=#{prefix}"
  end
end
