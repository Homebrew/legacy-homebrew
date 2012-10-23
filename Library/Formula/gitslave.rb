require 'formula'

class Gitslave < Formula
  homepage 'http://gitslave.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/gitslave/gitslave-2.0.2.tar.gz'
  sha1 'e27c3ed89f0dad0e7b6dffc424624c219d96296e'

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
