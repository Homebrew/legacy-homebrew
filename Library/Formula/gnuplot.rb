require 'formula'

class Gnuplot < Formula
  url 'http://downloads.sourceforge.net/project/gnuplot/gnuplot/4.4.3/gnuplot-4.4.3.tar.gz'
  homepage 'http://www.gnuplot.info'
  md5 '639603752996f4923bc02c895fa03b45'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'pango' # cairo support
  depends_on 'pdflib-lite' if ARGV.include? "--pdf"
  depends_on 'lua' unless ARGV.include? '--nolua'
  depends_on 'gd' unless ARGV.include? "--nogd"

  def options
    [
      ["--pdf", "Build with pdflib-lite support."],
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
            "--with-readline=#{readline.prefix}",
            "--disable-wxwidgets"]
    args << "--with-pdf=#{pdflib.prefix}" if ARGV.include? '--pdf'
    args << "--without-lua" if ARGV.include? "--nolua"
    if ARGV.include? '--nogd'
      args << '--without-gd'
    else
      args << "--with-gd=#{gd.prefix}"
    end

    system "./configure", *args
    system "make install"
  end
end
