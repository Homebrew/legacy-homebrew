class Nodebrew < Formula
  desc "Node.js version manager"
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/v0.8.1.tar.gz"
  sha256 "c976a879954dfb5dd657f1e93934ec182ffe4aa4e91ee2be0f7ece91cd25af6f"
  head "https://github.com/hokaccha/nodebrew.git"

  def install
    bin.install "nodebrew"
    system "#{bin}/nodebrew", "setup_dirs"
    bash_completion.install "completions/bash/nodebrew-completion" => "nodebrew"
    zsh_completion.install "completions/zsh/_nodebrew"
  end

  def caveats; <<-EOS.undent
    Add path:
      export PATH=$HOME/.nodebrew/current/bin:$PATH

    To use Homebrew's directories rather than ~/.nodebrew add to your profile:
      export NODEBREW_ROOT=#{var}/nodebrew
    EOS
  end

  test do
    assert shell_output("#{bin}/nodebrew ls-remote").include?("v0.10.0")
  end
end
