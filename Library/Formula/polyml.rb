require "formula"

class Polyml < Formula
  homepage "http://www.polyml.org"
  url "https://downloads.sourceforge.net/project/polyml/polyml/5.5.2/polyml.5.5.2.tar.gz"
  sha1 "8926046162c073d01c1b3bcfc744c63adfafc0d2"

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
