require "formula"

class Tnef < Formula
  homepage "http://sourceforge.net/projects/tnef/"
  url "https://downloads.sourceforge.net/project/tnef/tnef/tnef-1.4.12.tar.gz"
  sha1 "efa9aa2bb416e5c81317910a1b615931d79a8c7b"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
