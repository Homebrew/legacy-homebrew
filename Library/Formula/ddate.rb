require 'formula'

class Ddate < Formula
  homepage 'http://www.discordia.ch/Programs/'
  url 'www.discordia.ch/Programs/ddate.c'
  version '0.1.0'
  sha1 '41eafa66d577082b95e40a8f40ac054aa8ea45dc'

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install 'ddate'
  end
end
