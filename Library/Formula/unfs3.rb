require 'formula'

class Unfs3 < Formula
  url 'http://sourceforge.net/projects/unfs3/files/unfs3/0.9.22/unfs3-0.9.22.tar.gz'
  homepage 'http://unfs3.sourceforge.net'
  md5 'ddf679a5d4d80096a59f3affc64f16e5'

  def install
    ENV.j1 # Build is not parallel-safe
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
