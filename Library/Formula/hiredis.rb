require 'formula'

class Hiredis < Formula
  homepage 'https://github.com/antirez/hiredis'
  url 'https://github.com/antirez/hiredis/tarball/v0.11.0'
  sha1 '70ad9dd6d946563925ea8aecd64882a0f046ab05'

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    system "make", "install", "PREFIX=#{prefix}"
  end
end
