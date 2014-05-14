require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.6.2.tar.xz'
  sha256 '526c4a362f6b21ffbaa48fe9eed92f7c0af0be210f56160938fb1661a6f162b4'

  bottle do
    cellar :any
    sha1 "37c05776bfbb04a4fbfbed65e45a4fe62998f110" => :mavericks
    sha1 "1af25c7c875801b174fb3f81ee8fdb6a2f07b0f8" => :mountain_lion
    sha1 "a76cff03da8c62cd4cbabe35f62ad4fd97054d29" => :lion
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
