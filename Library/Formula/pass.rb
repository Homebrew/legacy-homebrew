require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.4.2.tar.xz'
  sha256 'a10a8016a3d6bb32891a9a4086ac0a049587db1a55c1ac3b431c66189bc1a302'

  head 'http://git.zx2c4.com/password-store', :using => :git

  depends_on 'xz' => :build
  depends_on 'pwgen'
  depends_on 'tree'
  depends_on 'gnu-getopt'
  depends_on 'gnupg2'

  def install
    system "make DESTDIR=#{prefix} PREFIX=/ install"
  end

  def test
    system "#{bin}/pass", "--version"
  end
end
