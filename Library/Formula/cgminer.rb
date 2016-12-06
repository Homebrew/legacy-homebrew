require 'formula'

class Cgminer < Formula
  homepage 'https://github.com/ckolivas/cgminer'
  url 'https://github.com/ckolivas/cgminer/archive/v2.10.4.zip'
  sha1 '026e03f35f23c26417d09a3288f7933969668001'

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
