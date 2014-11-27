require 'formula'

class Quantlib < Formula
  homepage 'http://quantlib.org/'
  url 'https://downloads.sourceforge.net/project/quantlib/QuantLib/1.4/QuantLib-1.4.tar.gz'
  sha1 'f31f4651011a8e38e8b2cc6c457760fe61863391'

  bottle do
    cellar :any
    revision 1
    sha1 "05127a732538048ea590627c768c83c9034ccf5d" => :yosemite
    sha1 "eff03577fd90569d8541d64161d9e08851d71ba8" => :mavericks
    sha1 "19d71ade61f7f55518dfed37ffa46114357b2056" => :mountain_lion
  end

  option :cxx11

  if build.cxx11?
    depends_on 'boost' => 'c++11'
  else
    depends_on 'boost'
  end

  # boost 1.57 compatibility; backported from master
  # https://github.com/lballabio/quantlib/issues/163
  patch do
    url "https://gist.githubusercontent.com/tdsmith/b2d5909db67b3173db02/raw/364ae3a09eb1dbb8bd14a2b71d42fda0b4e0d8cc/quantlib-boost-157.diff"
    sha1 "2ddc873bfb1baf33c7fc587211c281600ddfa182"
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
