require 'formula'

class Unfs3 < Formula
  homepage 'http://unfs3.sourceforge.net'
  url 'http://sourceforge.net/projects/unfs3/files/unfs3/0.9.22/unfs3-0.9.22.tar.gz'
  sha1 'a6c83e1210ce75836c672cd76e66577bfef7a17a'

  def install
    ENV.j1 # Build is not parallel-safe
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
