require 'formula'

class Mafft < Formula
  homepage 'http://mafft.cbrc.jp/alignment/software/index.html'
  url 'http://align.bmr.kyushu-u.ac.jp/mafft/software/mafft-6.717-with-extensions-src.tgz'
  sha1 '18d82340918949bbcdce659d4a09421ce06d67b1'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Clang does not allow default arguments in out-of-line definitions of
      class template members.
      EOS
  end

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
