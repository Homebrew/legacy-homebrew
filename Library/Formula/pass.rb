require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.2.tar.xz'
  sha256 '09b5ca5250be8137d4153b4c38659cedd33e2eeec832751a93add2c3ec434903'
  head 'http://git.zx2c4.com/password-store', :using => :git

  depends_on 'xz' => :build
  depends_on 'pwgen'
  depends_on 'tree'
  depends_on 'gnupg2'

  def install
    inreplace "src/password-store.sh" do |s|
      s.gsub! "gpg ", "gpg2 "
      s.gsub! "xclip -o -selection clipboard", "pbpaste"
      s.gsub! "xclip -selection clipboard", "pbcopy"
      s.gsub! "qdbus", "#qdbus"
      s.gsub! "base64", "openssl base64"
    end
    inreplace "man/pass.1", "xclip", "pbcopy"

    system "make DESTDIR=#{prefix} PREFIX=/ install"
  end

end
