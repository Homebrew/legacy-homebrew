require 'formula'

class Root < Formula
  homepage 'http://root.cern.ch/'
  url 'ftp://root.cern.ch/root/root_v5.32.00.macosx106-x86_64-gcc-4.2.tar.gz'
  md5 '68c9d33c997e444800151895c1ce94c1'
  version '5.32.00'

  def install
    #We just download the pre-built binary from the ROOT website and
    #copy it to the destination.  We exclude the man pages and install
    #them manually, as is required by Homebrew.  This solution is the
    #fastest and most reliable due to ROOT's extensive quirks.  This
    #solution is also more maintainable and the precompiled-binaries
    #include the most common ROOT options.
    #
    #It should be noted that ROOT requires initialization scripts
    #(as described in the caveats) and that ROOT installs them to
    #the bin directory (even when compiling from source).  It also
    #installs "rootmap" files into the lib directory, which are used
    #by ROOT's integrated C/C++ interpreter, CINT.  Unfortunately,
    #both of these pieces of functionality are heavily-ingrained in
    #the design and implementation of ROOT, and there is no way to
    #hack/patch around them to suppress the Homebrew warning
    #messages about them.
    system "cp -a `ls | grep -v man` #{prefix}/"
    man1.install Dir['man/man1/*.1']
  end

  def test
    system "root"
  end

  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For csh/tcsh users:
      source #{bin}/thisroot.csh
    For bash/csh users:
      . #{bin}/thisroot.sh

    EOS
  end
end
