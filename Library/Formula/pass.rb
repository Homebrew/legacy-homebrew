require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.3.1.tar.xz'
  sha256 '351c0e2eb3315ca317026e73f7654a6351f2674000d9476b18c1525cbc5d732d'

  head 'http://git.zx2c4.com/password-store', :using => :git

  depends_on 'xz' => :build
  depends_on 'pwgen'
  depends_on 'tree'
  depends_on 'gnu-getopt'
  depends_on 'gnupg2'

  def patches
    # Use ramdisk for volatile storage in OSX.
    "contrib/osx-ramdisk.patch"
  end

  def install
    inreplace "src/password-store.sh" do |s|
      s.gsub! "gpg ", "gpg2 "
      s.gsub! "xclip -o -selection clipboard", "pbpaste"
      s.gsub! "xclip -selection clipboard", "pbcopy"
      s.gsub! "qdbus", "#qdbus"
      s.gsub! "base64", "openssl base64"
      s.gsub! "getopt", Formula.factory('gnu-getopt').bin/"getopt"
    end
    inreplace "man/pass.1", "xclip", "pbcopy"

    system "make DESTDIR=#{prefix} PREFIX=/ install"
  end

  def test
      system "#{bin}/pass --version"
  end

end
