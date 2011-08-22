require 'formula'

class Wget < Formula
  homepage 'http://www.gnu.org/software/wget/'
  url 'http://ftp.gnu.org/gnu/wget/wget-1.12.tar.bz2'
  md5 '308a5476fc096a8a525d07279a6f6aa3'

  depends_on "openssl" if MacOS.leopard?
  depends_on "libidn" if ARGV.include? "--enable-iri"

  def options
    [["--enable-iri", "Enable iri support."]]
  end

  def patches
    # Fixes annoying TLS Subject Alternative Name bug encountered especially when using GitHub
    # Remove when 1.12.1 is released.
    # See https://savannah.gnu.org/bugs/?23934
    "http://savannah.gnu.org/file/wget-1.12-subjectAltNames.diff?file_id=18828"
  end

  def install
    args = ["--disable-debug", "--prefix=#{prefix}"]
    args << "--disable-iri" unless ARGV.include? "--enable-iri"

    system "./configure", *args
    system "make install"
  end
end
