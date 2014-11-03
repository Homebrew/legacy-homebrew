require "formula"

class Adns < Formula
  homepage "http://www.chiark.greenend.org.uk/~ian/adns/"
  url "http://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.5.0.tar.gz"
  sha1 "38306b8030c61a78bee85e33f34de876392ca4f8"
  head "git://git.chiark.greenend.org.uk/~ianmdlvl/adns.git"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/adnsheloex", "--version"
  end
end
