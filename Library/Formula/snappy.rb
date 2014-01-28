require 'formula'

class Snappy < Formula
  homepage 'http://snappy.googlecode.com'
  url 'https://snappy.googlecode.com/files/snappy-1.1.1.tar.gz'
  sha1 '2988f1227622d79c1e520d4317e299b61d042852'

  bottle do
    cellar :any
    revision 1
    sha1 '3d55ae60e55bef5a27a96d7b1b27f671935288a9' => :mavericks
    sha1 '7a26958f44511136965ae2b306ae79efddd4b44f' => :mountain_lion
    sha1 'e5e3f3b4f0227910851fcc832aea0f2b7b5f2292' => :lion
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
