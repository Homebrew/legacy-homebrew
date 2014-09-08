require 'formula'

class Quantlib < Formula
  homepage 'http://quantlib.org/'
  url 'https://downloads.sourceforge.net/project/quantlib/QuantLib/1.4/QuantLib-1.4.tar.gz'
  sha1 'f31f4651011a8e38e8b2cc6c457760fe61863391'

  bottle do
    cellar :any
    sha1 "4159c617207a756fc39e11755c8c0c41562ac48d" => :mavericks
    sha1 "d556348c0d2d44fe2b24167a99c8ac5c3c26bb79" => :mountain_lion
    sha1 "8fdc268cab283a11967df58489aa6df60c8f8779" => :lion
  end

  option :cxx11

  if build.cxx11?
    depends_on 'boost' => 'c++11'
  else
    depends_on 'boost'
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
