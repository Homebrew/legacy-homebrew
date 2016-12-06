require 'formula'
require 'hardware'

class Root < Formula
  homepage 'http://root.cern.ch/'
  if MacOS.prefer_64_bit?
    url 'ftp://root.cern.ch/root/root_v5.32.00.macosx106-x86_64-gcc-4.2.tar.gz'
    md5 '68c9d33c997e444800151895c1ce94c1'
  else
    url 'ftp://root.cern.ch/root/root_v5.32.00.macosx106-i386-gcc-4.2.tar.gz'
    md5 'ac70ea2fd6732b3b4cb8f40faa89b5c1'
  end
  version '5.32.00'

  def install
    #We just download the pre-built binary from the ROOT website and
    #simply install the various subdirectories to their respective
    #destinations.  This solution is the fastest and most reliable
    #due to ROOT's extensive quirks.  This solution is also more
    #maintainable and the precompiled-binaries include the most
    #common ROOT options.
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
    prefix.install ['cint', 'etc', 'fonts', 'geom', 'icons', 'macros',
                    'LICENSE', 'README', 'test', 'tmva', 'tutorials']
    bin.install Dir['bin/*']
    include.install Dir['include/*']
    lib.install Dir['lib/*']
    man.install Dir['man/*']
  end

  def test
    system "#{bin}/root"
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
