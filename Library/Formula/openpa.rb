require 'formula'

class Openpa < Formula
  homepage 'https://trac.mcs.anl.gov/projects/openpa'
  url 'https://trac.mcs.anl.gov/projects/openpa/raw-attachment/wiki/Downloads/openpa-1.0.3.tar.gz'
  md5 '46bcdfabf121af900b949edddb052079'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    ENV.j1 # Run tests serialized
    system "make check"
    system "make install"

  end
end
