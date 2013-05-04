require 'formula'

class Cgminer < Formula
  homepage 'https://github.com/ckolivas/cgminer'
  url 'http://ck.kolivas.org/apps/cgminer/cgminer-3.1.0.tar.bz2'
  sha1 'fd9d5e893be42813b1c7f844c017484b0f7f25a2'

  depends_on 'automake' => :build
  depends_on 'curl' => :build
  depends_on 'c-ares' => :build
  depends_on 'pkg-config' => :build

  depends_on 'libusb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-cpumining", "--enable-scrypt"
    system "make install"
  end
end
