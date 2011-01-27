require 'formula'

class Wget <Formula
  homepage 'http://www.gnu.org/software/wget/'
  url 'http://ftp.gnu.org/gnu/wget/wget-1.12.tar.bz2'
  md5 '308a5476fc096a8a525d07279a6f6aa3'

  depends_on "libidn" if ARGV.include? "--enable-iri"

  def options
    [["--enable-iri", "Enable iri support."]]
  end

  def install
    args = ["--disable-debug", "--prefix=#{prefix}"]
    args << "--disable-iri" unless ARGV.include? "--enable-iri"

    system "./configure", *args
    system "make install"
  end
end
