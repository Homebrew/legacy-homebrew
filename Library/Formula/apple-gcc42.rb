require 'formula'

class AppleGcc42 < Formula
  homepage 'http://r.research.att.com/tools/'
  url 'http://r.research.att.com/tools/gcc-42-5666.3-darwin11.pkg'
  mirror 'http://web.archive.org/web/20130512150329/http://r.research.att.com/tools/gcc-42-5666.3-darwin11.pkg'
  version '4.2.1-5666.3'
  sha1 '8fadde2a159082d6474fe9e325b6301e3c0bc84f'

  bottle do
    cellar :any
    revision 2
    sha1 'b1a3f8e2dd3d34bf9a978c3d6a0a4e73879caf18' => :mavericks
    sha1 'eb6940a80de4e0ab1d65f1729ee08f09e96d58e0' => :mountain_lion
    sha1 '7b6d895482b11885fd993f423d51ce7e91d017ab' => :lion
  end

  option 'with-gfortran-symlink', 'Provide gfortran symlinks'

  depends_on :macos => :lion

  def install
    system "/bin/pax", "--insecure", "-rz", "-f", "usr.pkg/Payload", "-s", ",./usr,#{prefix},"

    if build.with? "gfortran-symlink"
      safe_system "ln -sf #{bin}/gfortran-4.2 #{bin}/gfortran"
      safe_system "ln -sf #{man1}/gfortran-4.2.1 #{man1}/gfortran.1"
    end
  end

  def caveats
    <<-EOS.undent
      NOTE:
      This formula provides components that were removed from XCode in the 4.2
      release. There is no reason to install this formula if you are using a
      version of XCode prior to 4.2.

      This formula contains compilers built from Apple's GCC sources, build
      5666.3, available from:

        http://opensource.apple.com/tarballs/gcc

      All compilers have a `-4.2` suffix. A GFortran compiler is also included.
    EOS
  end
end
