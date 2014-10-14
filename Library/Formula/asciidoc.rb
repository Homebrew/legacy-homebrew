require 'formula'

class Asciidoc < Formula
  homepage 'http://www.methods.co.nz/asciidoc'
  url 'https://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.9/asciidoc-8.6.9.tar.gz'
  sha1 '82e574dd061640561fa0560644bc74df71fb7305'

  bottle do
    cellar :any
    sha1 "fe0cb89bae6cc28250c29141d349436c6d7c180e" => :mavericks
    sha1 "b4a455acf5666da7e13d4dc419069fc8220f111c" => :mountain_lion
    sha1 "b1769d0672ec6b2993ed816d4ad6c21683777983" => :lion
  end

  head do
    url 'https://code.google.com/p/asciidoc/', :using => :hg
    depends_on "autoconf" => :build
  end

  depends_on 'docbook'

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"

    # otherwise OS X's xmllint bails out
    inreplace 'Makefile', '-f manpage', '-f manpage -L'
    system "make install"
  end

  def caveats; <<-EOS.undent
      If you intend to process AsciiDoc files through an XML stage
      (such as a2x for manpage generation) you need to add something
      like:

        export XML_CATALOG_FILES=#{HOMEBREW_PREFIX}/etc/xml/catalog

      to your shell rc file so that xmllint can find AsciiDoc's
      catalog files.

      See `man 1 xmllint' for more.
    EOS
  end
end
