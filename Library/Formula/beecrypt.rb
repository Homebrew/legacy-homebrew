require 'formula'

class Beecrypt < Formula
  url 'http://sourceforge.net/projects/beecrypt/files/beecrypt/4.2.1/beecrypt-4.2.1.tar.gz'
  homepage 'http://beecrypt.sourceforge.net'
  sha256 '286f1f56080d1a6b1d024003a5fa2158f4ff82cae0c6829d3c476a4b5898c55d'

  depends_on "icu4c"

  def install
    # If we don't explicitly set CFLAGS/CXXFLAGS here, Homebrew creates one with an -march
    # option in it.  This causes the Beecrypt compile to fail.
    ENV['CFLAGS'] = '-O2 -msse4.1 -w -pipe'
    ENV['CXXFLAGS'] = '-O2 -msse4.1 -w -pipe'

    system "./configure", "--prefix=#{prefix}", "--disable-openmp", "--without-java", "--without-python"
    system "make"
    system "make install"
  end
end
