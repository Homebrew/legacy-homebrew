require "formula"

class Fftextract < Formula
  homepage "http://omras2.doc.gold.ac.uk/software/fftextract/"
  url "http://trac.greenstone.org/export/29233/gs3-extensions/audioDB/trunk/src/src/fftExtract-QM-svn.tar.gz"
  sha1 "5c3e4974f72a1d70b22874656424a893c701c735"

  depends_on "fftw"
  depends_on "libsndfile"

  patch :p0 do
    url "https://gist.githubusercontent.com/dardo82/1b97bcc1c837bfbbe606/raw/016b6e298764a715d2f7ac71ea72b21d3f922c43/fftExtract-Makefile.diff"
    sha1 "25fea541f1b48cb2aad8d6160f26ff081b0958b8"
  end

  def install
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/fftExtract"
  end
end
