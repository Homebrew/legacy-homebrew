require 'formula'

class Snappy < Formula
  homepage 'http://snappy.googlecode.com'
  url 'https://snappy.googlecode.com/files/snappy-1.1.1.tar.gz'
  sha1 '2988f1227622d79c1e520d4317e299b61d042852'

  bottle do
    cellar :any
    sha1 '21535c1ead6717986b39543a5012aed1c0c8af1d' => :mavericks
    sha1 'f3606774ca0fa5114fea117310f54575190ae4d5' => :mountain_lion
    sha1 'd64a682c7172f950e82fe846050c2cf7faa9b70e' => :lion
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
