class Polyml < Formula
  desc "Standard ML implementation"
  homepage "http://www.polyml.org"
  url "https://downloads.sourceforge.net/project/polyml/polyml/5.5.2/polyml.5.5.2.tar.gz"
  sha256 "73fd2be89f7e3ff0567e27ef525ef788775d9f963d6db54069cb34d53040a682"

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
