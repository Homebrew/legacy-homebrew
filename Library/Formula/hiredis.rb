require 'formula'

class Hiredis < Formula
  homepage 'https://github.com/antirez/hiredis'
  url 'https://github.com/antirez/hiredis/tarball/v0.10.1'
  sha1 '3a16d7ac39f5a3a96a3fb08732a9af45e275a3b8'

  head 'https://github.com/antirez/hiredis.git'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      argument to 'va_arg' is of incomplete type 'void'
      This is fixed in HEAD, and can be removed for the next release.
      EOS
  end unless ARGV.build_head?

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    system "make", "install", "PREFIX=#{prefix}"
  end
end
