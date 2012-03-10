require 'formula'

class Mscgen < Formula
  url 'http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz'
  homepage 'http://www.mcternan.me.uk/mscgen/'
  md5 '65c90fb5150d7176b65b793f0faa7377'

  depends_on 'pkg-config' => :build
  depends_on 'gd' => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
