require 'formula'

class DmtxWrappersPython < Formula
  url 'git://libdmtx.git.sourceforge.net/gitroot/libdmtx/dmtx-wrappers'
  #, :tag => 'v0.7.4' # dmtx-wrappers has not yet been tagged
  # http://sourceforge.net/mailarchive/message.php?msg_id=27861701
  version '0.7.4'
  homepage 'http://www.libdmtx.org'

  depends_on 'pkg-config' => :build

  # for python wrappers depends on PIL, but not the version from homebrew

  def patches
    { :p0 => "https://gist.github.com/raw/1251404/dmtx-wrapper-osx.patch" }
  end

  def install
    # Don't try to build extensions for PPC
    if Hardware.is_32_bit?
      ENV['ARCHFLAGS'] = "-arch i386"
    else
      ENV['ARCHFLAGS'] = "-arch i386 -arch x86_64"
    end

    # patch configure.ac


    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "cd python; python setup.py build_ext"
    system "cd python; python setup.py install"
  end

  def test
    system "true"
  end
end
