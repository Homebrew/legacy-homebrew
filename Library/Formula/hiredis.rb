require 'formula'

class Hiredis < Formula
  homepage 'https://github.com/redis/hiredis'
  url 'https://github.com/redis/hiredis/tarball/v0.11.0'
  sha1 '26eb4459943530b4be66fd253c5c8f4dd86c2fa3'

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    system "make", "install", "PREFIX=#{prefix}"
  end
end
