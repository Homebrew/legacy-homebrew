require 'formula'

class Wget < Formula
  homepage 'http://www.gnu.org/software/wget/'
  url 'http://ftpmirror.gnu.org/wget/wget-1.13.4.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/wget/wget-1.13.4.tar.bz2'
  md5 '12115c3750a4d92f9c6ac62bac372e85'

  head 'bzr://http://bzr.savannah.gnu.org/r/wget/trunk'

  depends_on "openssl" if MacOS.leopard?
  depends_on "libidn" if ARGV.include? "--enable-iri"

  if ARGV.build_head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  def options
    [["--enable-iri", "Enable iri support."]]
  end

  def install
    system "./bootstrap" if ARGV.build_head?
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--with-ssl=openssl"]

    args << "--disable-iri" unless ARGV.include? "--enable-iri"

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/wget", "-O", "-", "www.google.com"
  end
end
