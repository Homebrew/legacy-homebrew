require 'formula'

class Libpar2 < Formula
  url 'http://sourceforge.net/projects/parchive/files/libpar2/0.2/libpar2-0.2.tar.gz'
  homepage 'http://parchive.sourceforge.net/'
  sha1 '4b3da928ea6097a8299aadafa703fc6d59bdfb4b'

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      ./par2fileformat.h:87:25: error: flexible array member 'entries' of non-POD element type 'FILEVERIFICATIONENTRY []'
    EOS
  end

  def patches
    # patch from NZBGet 9.1, bugfix and adds ability to cancel par check
    "https://gist.github.com/raw/4576230/e722f2113195ee9b8ee67c1c424aa3f2085b1066/libpar2-0.2-nzbget.patch"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
