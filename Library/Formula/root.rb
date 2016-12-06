require 'formula'

class Root < Formula
  homepage 'http://root.cern.ch'
  url 'ftp://root.cern.ch/root/root_v5.32.01.source.tar.gz'
  version '5.32.01'
  md5 'c8f28bb483e0b32208fb153c1ea6af7c'

  depends_on 'fftw' => :optional

  def install

    system "./configure", "--prefix=#{prefix}", "--enable-roofit"
    system "make"
    system "make install"

    prefix.install ['test'] # needed to run test suite

  end

  def test
    system "make -C #{prefix}/test/ hsimple"
    system "#{prefix}/test/hsimple"
  end


  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For csh/tcsh users:
      source #{bin}/thisroot.csh
    For bash/zsh users:
      . #{bin}/thisroot.sh

    EOS
  end
end
