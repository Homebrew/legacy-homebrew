require 'formula'

class Ddate < Formula
  url 'www.discordia.ch/Programs/ddate.c'
  homepage 'http://www.discordia.ch/Programs/'
  sha1 '41eafa66d577082b95e40a8f40ac054aa8ea45dc'
  version '0.1.0'

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install 'ddate'
  end
end
