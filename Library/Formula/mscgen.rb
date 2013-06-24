require 'formula'

class Mscgen < Formula
  homepage 'http://www.mcternan.me.uk/mscgen/'
  url 'http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz'
  sha1 'cb718587e5fda99ca8b36801c57ea794d07bf211'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gd' => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
