require 'formula'

class Mafft < Formula
  homepage 'http://mafft.cbrc.jp/alignment/software/index.html'
  url 'http://align.bmr.kyushu-u.ac.jp/mafft/software/mafft-6.717-with-extensions-src.tgz'
  md5 '2fc3acfce3a48f9804e8ca5e22bb984d'

  def install
    cd 'core' do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "PREFIX=#{prefix}",
                     "MANDIR=#{man1}",
                     "install"
    end

    cd 'extensions' do
      system "make", "CC=#{ENV.cc}",
                     "CXX=#{ENV.cxx}",
                     "CXXFLAGS=#{ENV.cxxflags}",
                     "CFLAGS=#{ENV.cflags}",
                     "PREFIX=#{prefix}",
                     "MANDIR=#{man1}",
                     "install"
    end
  end
end
