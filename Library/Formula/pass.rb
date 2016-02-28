class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.6.5.tar.xz"
  sha256 "337a39767e6a8e69b2bcc549f27ff3915efacea57e5334c6068fcb72331d7315"
  head "https://git.zx2c4.com/password-store", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "816ba5fa3a4e8d820b1bcd12237adfde7fa07a102cb2c90f24d581ebc948badf" => :el_capitan
    sha256 "6c6d120e746e61a47d5dbcc72ab3de36cfc3099d2a6016b9193f71c1faed8db5" => :yosemite
    sha256 "37712a4cf9477a2d33a1ebf105cbe2258aab7ab1f22aebf36cd96ab6a8fdd568" => :mavericks
    sha256 "7ac1d75c2a790483bec2b8900f493d8f620d58a55b13094dce3c70e7d8dc0173" => :mountain_lion
  end

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
