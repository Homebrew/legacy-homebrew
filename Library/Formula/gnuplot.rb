require 'formula'

class Gnuplot < Formula
  homepage 'http://www.gnuplot.info'
  url 'http://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.0/gnuplot-4.6.0.tar.gz'
  md5 '8e6e92b4596ea0eb75e16a57fc79efec'
  head 'cvs://:pserver:anonymous@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot:gnuplot', :using => :cvs

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'pango'
  depends_on 'pdflib-lite' if ARGV.include? "--pdf"
  depends_on 'lua' unless ARGV.include? '--nolua'
  depends_on 'gd' unless ARGV.include? "--nogd"
  depends_on 'wxmac' if ARGV.include? "--wx"

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
    system "#{bin}/gnuplot", "--version"
  end
end
