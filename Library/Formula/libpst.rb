require 'formula'

class Libpst < Formula
  homepage 'http://www.five-ten-sg.com/libpst/'
  url 'http://www.five-ten-sg.com/libpst/packages/libpst-0.6.55.tar.gz'
  sha1 'c81df95509494c99222b0b603f7500dd9caceff1'
  revision 1

  bottle do
    cellar :any
    revision 2
    sha1 "b90a60bae5163fa853ea1e1bfe8c4149d0287457" => :yosemite
    sha1 "143ec60a13f3ccfbb46cb9039ac31505f5b904e5" => :mavericks
    sha1 "7d0df0df98649f182c6b493eab1fc6ad77b7b1f7" => :mountain_lion
  end

  option 'pst2dii', 'Build pst2dii using gd'

  depends_on :python => :optional
  depends_on 'gd' if build.include? 'pst2dii'
  depends_on "boost"
  depends_on "boost-python" if build.with? "python"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << '--disable-dii' unless build.include? 'pst2dii'
    if build.with? 'python'
      args << '--enable-python' << '--with-boost-python=mt'
    else
      args << '--disable-python'
    end
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
