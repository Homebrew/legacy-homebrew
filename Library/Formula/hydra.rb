require 'formula'

class Hydra < Formula
  homepage 'http://www.thc.org/thc-hydra/'
  url 'http://www.thc.org/releases/hydra-8.0.tar.gz'
  sha1 'd1a705985846caf77c291461f391a43457cc76e5'

  bottle do
    cellar :any
    sha1 "b36a930ea26de765fe8b7f5c7b9b7a81006f291a" => :mavericks
    sha1 "005cc151ced33f728bef85ef09d437e9482d02e9" => :mountain_lion
    sha1 "0a44df2fc931a367d41d3c2147802359a9d997f7" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make all install"
    share.install prefix/"man" # Put man pages in correct place
  end
end
