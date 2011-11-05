require 'formula'

class Ddate < Formula
  url 'www.discordia.ch/Programs/ddate.c'
  homepage 'http://www.discordia.ch/Programs/'
  md5 'b4c58c51040f8529a274ed8f57f929a8'
  version '0.1.0'

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install 'ddate'
  end
end
