require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng15/1.5.13/libpng-1.5.13.tar.gz'
  sha1 '43a86bc5ba927618fd6c440bc4fd770d87d06b80'

  keg_only :provided_pre_mountain_lion

  option :universal

  bottle do
    sha1 '83c6be83e86404f41982e5e1e6877924fe737bdf' => :mountainlion
    sha1 '9a86cc5cec4cb19bd04c7c1e93595d96ebcde66f' => :lion
    sha1 '3ba3f991b61afcaf0f369da89443738443d4effe' => :snowleopard
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
