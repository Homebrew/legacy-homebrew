require 'formula'

class Root < Formula
  homepage 'http://root.cern.ch'
  url 'ftp://root.cern.ch/root/root_v5.34.10.source.tar.gz'
  version '5.34.10'
  sha1 '2dc0af12e531c4f2314a9fbd7dd4f5fee924d71c'

  depends_on 'fftw' => :optional
  depends_on :x11
  depends_on :python

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
           "--enable-builtin-glew",
           "--prefix=#{prefix}",
           "--etcdir=#{prefix}/etc/root",
           "--mandir=#{man}"
    system "make"
    system "make install"

    prefix.install 'test' # needed to run test suite

    # brew audit doesn't like non-executables in bin
    # so we will move {thisroot,setxrd}.{c,}sh to libexec
    # (and change any references to them)
    libexec.mkpath
    mv bin/'thisroot.sh',  libexec/'thisroot.sh'
    mv bin/'thisroot.csh', libexec/'thisroot.csh'
    mv bin/'setxrd.sh',    libexec/'setxrd.sh'
    mv bin/'setxrd.csh',   libexec/'setxrd.csh'
    inreplace bin/    'roots',                              'bin/thisroot', 'libexec/thisroot'
    inreplace prefix/ 'etc/root/proof/utils/pq2/setup-pq2', 'bin.thisroot', 'libexec.thisroot'
    inreplace share/  'doc/root/INSTALL',                   'bin/thisroot', 'libexec/thisroot'
    inreplace share/  'doc/root/README',                    'bin/thisroot', 'libexec/thisroot'
    inreplace man/    'setup-pq2.1',                        'bin.thisroot', 'libexec.thisroot'
    inreplace libexec/'thisroot.sh',                        'bin/thisroot', 'libexec/thisroot'
    inreplace libexec/'thisroot.csh',                       'bin/thisroot', 'libexec/thisroot'

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
      source `brew --prefix root`/libexec/thisroot.csh
    For bash/zsh users:
      . $(brew --prefix root)/libexec/thisroot.sh

    (Note that other ROOT installations [including Homebrew,
    before ROOT 5.34.10] may put these scripts under `bin`. We
    moved them to `libexec` in an effort to keep `bin` clean.)

    EOS
  end
end
