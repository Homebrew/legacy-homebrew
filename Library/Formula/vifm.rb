require "formula"

class Vifm < Formula
  homepage "http://vifm.sourceforge.net/index.html"
  url "https://downloads.sourceforge.net/project/vifm/vifm/vifm-0.7.7.tar.bz2"
  sha1 "edf5b245ca582e5a7b127a87fa5ab2ad210b76c3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
