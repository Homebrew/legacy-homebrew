require 'formula'

class Gnuplot < Formula
  url 'http://downloads.sourceforge.net/project/gnuplot/gnuplot/4.4.4/gnuplot-4.4.4.tar.gz'
  homepage 'http://www.gnuplot.info'
  md5 '97a43328e81e57ebed7f135ca0c07e82'
  head 'cvs://:pserver:anonymous@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot:gnuplot', :using => :cvs

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'pango' # cairo support
  depends_on 'pdflib-lite' if ARGV.include? "--pdf"
  depends_on 'lua' unless ARGV.include? '--nolua'
  depends_on 'gd' unless ARGV.include? "--nogd"
  depends_on 'wxmac' if ARGV.include? "--wx"

  def options
    [
      ["--pdf", "Build with pdflib-lite support."],
      ["--wx", "Build with wxWidgets support."],
      ["--nolua", "Build without lua support."],
      ["--nogd", "Build without gd support."]
    ]
  end

  def install
    # Help configure find libraries
    ENV.x11
    readline = Formula.factory 'readline'
    pdflib = Formula.factory 'pdflib-lite'
    gd = Formula.factory 'gd'

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-readline=#{readline.prefix}"]

    args << "--disable-wxwidgets" unless ARGV.include? "--wx"
    args << "--with-pdf=#{pdflib.prefix}" if ARGV.include? '--pdf'
    args << "--without-lua" if ARGV.include? "--nolua"

    if ARGV.include? '--nogd'
      args << '--without-gd'
    else
      args << "--with-gd=#{gd.prefix}"
    end

    system "autoreconf" if ARGV.build_head?

    system "./configure", *args
    system "make install"
  end

  def test
    system "gnuplot --version"
  end
end
