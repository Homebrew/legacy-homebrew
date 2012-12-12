require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.4.2.tar.xz'
  sha256 'ac5261b176e2be60b44c5c785dc5770a3e0f459bc6dbc42136679d68d3986e04'
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
