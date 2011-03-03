require 'formula'

class Gnuplot <Formula
  url 'http://downloads.sourceforge.net/project/gnuplot/gnuplot/4.4.2/gnuplot-4.4.2.tar.gz'
  homepage 'http://www.gnuplot.info'
  md5 'a4f0dd89f9b9334890464f687ddd9f50'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gd' unless ARGV.include? "--nogd"
  depends_on 'pdflib-lite' if ARGV.include? "--pdf"

  def options
    [
      ["--pdf", "Build with pdf support."],
      ["--without-lua", "Build without lua support."],
      ["--nogd", "Build without gd support."]
    ]
  end

  def install
    ENV.x11
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-readline=#{prefix}",
            "--disable-wxwidgets"]
    args << "--without-lua" if ARGV.include? "--without-lua"

    system "./configure", *args
    system "make install"
  end
end
