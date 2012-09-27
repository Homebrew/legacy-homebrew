require 'formula'

class Gitslave < Formula
  url 'http://downloads.sourceforge.net/project/gitslave/gitslave-2.0.1.tar.gz'
  homepage 'http://gitslave.sourceforge.net'
  sha1 'caf4f7525ec6c97b745b84e673b7fc3ed3672305'

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
