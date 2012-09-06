require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.1.2.tar.xz'
  sha256 'c31f311590d5c5a53ae8a89b1e74c2896cdd072ccff005cb6dc2c31e97907672'


  depends_on 'pwgen'
  depends_on 'tree'
  depends_on 'gnupg2'
  depends_on 'xz' => :build


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
