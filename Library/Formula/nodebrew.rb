require "formula"

class Nodebrew < Formula
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/v0.7.4.tar.gz"
  sha1 "b60f9048837a15eef2420e9ffbced6d57b753534"
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
