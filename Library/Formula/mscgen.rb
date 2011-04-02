require 'formula'

class Mscgen < Formula
  url 'http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.19.tar.gz'
  homepage 'http://www.mcternan.me.uk/mscgen/'
  md5 '9ee92974529cbba5a058325b6607c263'

  depends_on 'pkg-config' => :build
  depends_on 'gd' => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
