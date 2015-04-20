require 'formula'

class Unfs3 < Formula
  homepage 'http://unfs3.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/unfs3/unfs3/0.9.22/unfs3-0.9.22.tar.gz'
  sha1 'a6c83e1210ce75836c672cd76e66577bfef7a17a'

  head do
    url 'https://svn.code.sf.net/p/unfs3/code/trunk/'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    ENV.j1 # Build is not parallel-safe
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
