require 'formula'

class Minuit2 < Formula
  homepage 'http://lcgapp.cern.ch/project/cls/work-packages/mathlibs/minuit/index.html'
  url 'http://www.cern.ch/mathlibs/sw/5_28_00/Minuit2/Minuit2-5.28.00.tar.gz'
  md5 '536a1d29e5cc9bd4499d17d665021370'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-pic",
                          "--disable-openmp",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
