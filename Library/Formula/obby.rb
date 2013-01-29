require 'formula'

class Obby < Formula
  homepage 'http://gobby.0x539.de'
  url 'http://releases.0x539.de/obby/obby-0.4.7.tar.gz'
  sha1 'efe4e6b406eb0628af63e88807d5d2115d88f390'

  depends_on 'pkg-config' => :build
  depends_on 'net6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
