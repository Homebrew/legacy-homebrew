require "formula"

class Nodebrew < Formula
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/v0.8.0.tar.gz"
  sha1 "5f3ec97e267fbccffcd3732a0a2436daa3a09d48"
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
