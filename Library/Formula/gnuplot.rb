require 'formula'

class Gnuplot < Formula
  homepage 'http://www.gnuplot.info'
  url 'http://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.0/gnuplot-4.6.0.tar.gz'
  sha1 '9a43ae13546d97d4b174533ddac31a14e0edc9b2'

  head 'cvs://:pserver:anonymous@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot:gnuplot', :using => :cvs

  option 'pdf', 'Build with pdflib-lite support.'
  option 'wx', 'Build with wxWidgets support.'
  option 'nolua', 'Build without lua support.'
  option 'nogd', 'Build without gd support.'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'pango'
  depends_on :x11
  depends_on 'pdflib-lite' if build.include? 'pdf'
  depends_on 'lua' unless build.include? 'nolua'
  depends_on 'gd' unless build.include? 'nogd'
  depends_on 'wxmac' if build.include? 'wx'

  def install
    # Help configure find libraries
    readline = Formula.factory 'readline'
    pdflib = Formula.factory 'pdflib-lite'
    gd = Formula.factory 'gd'

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-readline=#{readline.prefix}"]

    args << '--disable-wxwidgets' unless build.include? 'wx'
    args << "--with-pdf=#{pdflib.prefix}" if build.include? 'pdf'
    args << '--without-lua' if build.include? 'nolua'

    if build.include? 'nogd'
      args << '--without-gd'
    else
      args << "--with-gd=#{gd.prefix}"
    end

    system 'autoreconf' if build.head?

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/gnuplot", "--version"
  end
end
