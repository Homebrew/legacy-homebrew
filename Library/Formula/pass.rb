require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.5.tar.xz'
  sha256 '6d3f327b039bb64157662d3d11af5ecebd3774b886ad6e52a684654d9914a8f3'

  head 'http://git.zx2c4.com/password-store', :using => :git

  depends_on 'pwgen'
  depends_on 'tree'
  depends_on 'gnu-getopt'
  depends_on 'gnupg2'

  def install
    system "make DESTDIR=#{prefix} PREFIX=/ install"
    share.install "contrib"
    zsh_completion.install "src/completion/pass.zsh-completion" => "_pass"
  end

  test do
    system "#{bin}/pass", "--version"
  end
end
