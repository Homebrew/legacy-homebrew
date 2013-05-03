require 'formula'

class Root < Formula
  homepage 'http://root.cern.ch'
  url 'ftp://root.cern.ch/root/root_v5.34.05.source.tar.gz'
  version '5.34.05'
  sha1 'fbe19bb0fc7559cbd69c34c4ab2c4bfb150bac13'

  depends_on 'fftw' => :optional
  depends_on :x11

  def install
    #Determine architecture
    arch = MacOS.prefer_64_bit? ? 'macosx64' : 'macosx'

    # N.B. that it is absolutely essential to specify
    # the --etcdir flag to the configure script.  This is
    # due to a long-known issue with ROOT where it will
    # not display any graphical components if the directory
    # is not specified
    #
    # => http://root.cern.ch/phpBB3/viewtopic.php?f=3&t=15072
    system "./configure",
           "#{arch}",
           "--all",
           "--prefix=#{prefix}",
           "--etcdir=#{prefix}/etc/root",
           "--mandir=#{man}"
    system "make"
    system "make install"

    prefix.install 'test' # needed to run test suite

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
      source `brew --prefix root`/bin/thisroot.csh
    For bash/zsh users:
      . $(brew --prefix root)/bin/thisroot.sh

    EOS
  end
end
