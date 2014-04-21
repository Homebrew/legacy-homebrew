require 'formula'

class Adplug < Formula
  homepage 'http://adplug.sf.net'
  url 'https://downloads.sourceforge.net/project/adplug/AdPlug%20core%20library/2.2.1/adplug-2.2.1.tar.bz2'
  sha1 '5023282ff44f183c9b6d7da9f57f51595742a5f7'

  depends_on 'pkg-config' => :build
  depends_on 'libbinio'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
