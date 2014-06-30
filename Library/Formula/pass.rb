require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.6.2.tar.xz'
  sha256 '526c4a362f6b21ffbaa48fe9eed92f7c0af0be210f56160938fb1661a6f162b4'

  bottle do
    cellar :any
    sha1 "d6d4b6ddac09e4a6ff3d7f65de71e61563844a00" => :mavericks
    sha1 "fa6cee4d76760ff1c714b6936217074cc12be230" => :mountain_lion
    sha1 "c3288d0571d2b82244171917a9a808dca7098e3c" => :lion
  end

  head 'http://git.zx2c4.com/password-store', :using => :git

  depends_on 'pwgen'
  depends_on 'tree'
  depends_on 'gnu-getopt'
  depends_on 'gnupg2'

  def install
    system "make DESTDIR=#{prefix} PREFIX=/ install"
    share.install "contrib"
    zsh_completion.install "src/completion/pass.zsh-completion" => "_pass"
    bash_completion.install "src/completion/pass.bash-completion" => "password-store"
  end

  test do
    system "#{bin}/pass", "--version"
  end
end
