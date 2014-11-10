require "formula"

class Cracklib < Formula
  homepage "http://cracklib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cracklib/cracklib/2.9.2/cracklib-2.9.2.tar.gz"
  sha1 "a780211a87a284297aa473fe2b50584b842a0e98"

  bottle do
  end

  depends_on "gettext"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{HOMEBREW_PREFIX}/share/cracklib-words"
    system "make", "install"
  end
end
