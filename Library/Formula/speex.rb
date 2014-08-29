require 'formula'

class Speex < Formula
  homepage 'http://speex.org'
  url 'http://downloads.us.xiph.org/releases/speex/speex-1.2rc1.tar.gz'
  sha1 '52daa72572e844e5165315e208da539b2a55c5eb'

  bottle do
    cellar :any
    sha1 "231116d30e70bf1256773247ae3fec510ed5730e" => :mavericks
    sha1 "a225f5ca56787ae1172438012d7f2738dbb27430" => :mountain_lion
    sha1 "1660d549305cc565e903ecf0429a82418981de00" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libogg' => :optional

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
