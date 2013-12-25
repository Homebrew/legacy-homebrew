require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng16/1.6.8/libpng-1.6.8.tar.xz'
  sha1 'acdb0a45d80c90b39b56a41075003d4726f3558c'

  bottle do
    cellar :any
    revision 1
#    sha1 '039e4a626f4cbcbfa14349f86f33663ebc9d20d8' => :mavericks
    sha1 '6f9f7ad1ea035e897845dc3f4d3909a92664dbb8' => :mountain_lion
    sha1 '53e282b87f737dc16ddb0700585b5754cec6b913' => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
