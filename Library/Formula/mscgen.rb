require 'formula'

class Mscgen < Formula
  homepage 'http://www.mcternan.me.uk/mscgen/'
  url 'http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz'
  sha1 'cb718587e5fda99ca8b36801c57ea794d07bf211'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gd' => :recommended
  depends_on 'freetype' => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking"]

    args << "--with-freetype" if build.with? 'freetype'

    system "./configure", *args
    system "make install"
  end
end
