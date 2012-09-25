require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.4.tar.xz'
  sha256 '2e94b0078abdf4673f3c22bde048776a3c12776b1bc98c22e8fb6e684b0b4a9e'
  head 'http://git.zx2c4.com/password-store', :using => :git

  depends_on 'xz' => :build
  depends_on 'pwgen'
  depends_on 'tree'
  depends_on 'gnu-getopt'
  depends_on 'gnupg2'

  def install
    inreplace "contrib/pass.bash-completion", "gpg ", "gpg2 "
    system "make DESTDIR=#{prefix} PREFIX=/ install"
  end

  def test
    system "#{bin}/pass", "--version"
  end

end
