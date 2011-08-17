require 'formula'

class Wget < Formula
  homepage 'http://gnu.org/software/wget/'
  url 'http://ftp.gnu.org/gnu/wget/wget-1.13.1.tar.gz'
  sha256 '4bc25b2405a44cb1095ca326b4403f7ab5be45b6b72c317fe7e3a20d8b100e60'

  depends_on "openssl" if MacOS.leopard?
  depends_on "libidn" if ARGV.include? "--enable-iri"

  def options
    [["--enable-iri", "Enable iri support."]]
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--with-ssl=openssl",
            "--prefix=#{prefix}"]
    args << "--disable-iri" unless ARGV.include? "--enable-iri"

    system "./configure", *args
    system "make install"
  end
end
