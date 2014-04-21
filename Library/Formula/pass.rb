require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.5.tar.xz'
  sha256 '6d3f327b039bb64157662d3d11af5ecebd3774b886ad6e52a684654d9914a8f3'

  bottle do
    cellar :any
    revision 1
    sha1 "b08dd30932ce30c4a64a4886f3a7c6c1f1ab847f" => :mavericks
    sha1 "1b127403b8f6e4cb09275ba51fa2a8e4f0e7dd34" => :mountain_lion
    sha1 "16b60f64f369aa2b0a2d7e7c6403beaa6a3eacba" => :lion
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
