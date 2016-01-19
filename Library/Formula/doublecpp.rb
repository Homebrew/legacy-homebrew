class Doublecpp < Formula
  desc "Double dispatch in C++"
  homepage "http://doublecpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/doublecpp/doublecpp-0.6.3.tar.gz"
  sha256 "232f8bf0d73795558f746c2e77f6d7cb54e1066cbc3ea7698c4fba80983423af"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
