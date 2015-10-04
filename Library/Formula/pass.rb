class Pass < Formula
  desc "Password manager"
  homepage "http://www.passwordstore.org/"
  url "http://git.zx2c4.com/password-store/snapshot/password-store-1.6.5.tar.xz"
  sha256 "337a39767e6a8e69b2bcc549f27ff3915efacea57e5334c6068fcb72331d7315"

  bottle do
    cellar :any_skip_relocation
    sha256 "816ba5fa3a4e8d820b1bcd12237adfde7fa07a102cb2c90f24d581ebc948badf" => :el_capitan
    sha1 "f18ca5f0e15ac3de2cbb6757839fd44f45c3e823" => :yosemite
    sha1 "200e667bccf5219021a59f666e9b9e002367a6f7" => :mavericks
    sha1 "8e7a8b7da7c7016c7657c5093141c4b30b7abe98" => :mountain_lion
  end

  head "http://git.zx2c4.com/password-store", :using => :git

  depends_on "pwgen"
  depends_on "tree"
  depends_on "gnu-getopt"
  depends_on :gpg

  def install
    system "make", "PREFIX=#{prefix}", "install"
    share.install "contrib"
    zsh_completion.install "src/completion/pass.zsh-completion" => "_pass"
    bash_completion.install "src/completion/pass.bash-completion" => "password-store"
    fish_completion.install "src/completion/pass.fish-completion" => "pass.fish"
  end

  test do
    system "#{bin}/pass", "--version"
  end
end
