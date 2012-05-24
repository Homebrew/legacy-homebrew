require 'formula'

class Ifuse < Formula
  url 'http://www.libimobiledevice.org/downloads/ifuse-1.1.2.tar.bz2'
  homepage 'http://www.libimobiledevice.org/'
  md5 '4152526b2ac3c505cb41797d997be14d'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libimobiledevice'
  depends_on 'fuse4x'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info fuse4x-kext`
      before trying to use a FUSE-based filesystem.
    EOS
  end
end
