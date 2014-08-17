require "formula"

class Tnef < Formula
  homepage "http://sourceforge.net/projects/tnef/"
  url "https://downloads.sourceforge.net/project/tnef/tnef/tnef-1.4.11.tar.gz"
  sha1 "8759770fc3bf6d53bcf8426499f1272d3e9c541f"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
