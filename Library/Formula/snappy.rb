require 'formula'

class Snappy < Formula
  homepage 'http://snappy.googlecode.com'
  url 'https://snappy.googlecode.com/files/snappy-1.1.1.tar.gz'
  sha1 '2988f1227622d79c1e520d4317e299b61d042852'

  bottle do
    cellar :any
    revision 2
    sha256 "ee479c2aa998b56012f5c533a020bb66824388b1392b18b47394a42f45dc68bf" => :yosemite
    sha256 "f16a3840789560e902db8cc57be39fb7c57378d831d8f6a8798d78b3949d1de7" => :mavericks
    sha256 "4753cbe46233824642eb901b2b03ed205db610387b28bc7ea678ccd2bf133687" => :mountain_lion
  end

  option :universal

  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
