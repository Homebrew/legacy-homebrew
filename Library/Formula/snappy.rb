require 'formula'

class Snappy < Formula
  homepage 'http://snappy.googlecode.com'
  url 'http://snappy.googlecode.com/files/snappy-1.0.5.tar.gz'
  sha1 '3a3df859cf33f78f8e945c3f67f28685f0f38bb1'

  option :universal

  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
