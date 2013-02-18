require 'formula'

class Cgminer < Formula
  homepage 'https://github.com/ckolivas/cgminer'
  url 'https://nodeload.github.com/ckolivas/cgminer/legacy.tar.gz/master'
  sha1 'bc2864b252859b51300b409bb78a270da1920198'
  version '2.10.5'

  depends_on 'automake' => :build
  depends_on 'curl' => :build
  depends_on 'c-ares' => :build
  depends_on 'libusb'
  depends_on 'pkg-config' => :build

  def install
    ENV['NOCONFIGURE'] = '1'

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
    "--prefix=#{prefix}", "--enable-cpumining"
    system "make install"
  end
end
