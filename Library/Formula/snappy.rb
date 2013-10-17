require 'formula'

class Snappy < Formula
  homepage 'http://snappy.googlecode.com'
  url 'https://snappy.googlecode.com/files/snappy-1.1.1.tar.gz'
  sha1 '2988f1227622d79c1e520d4317e299b61d042852'

  option :universal

  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
