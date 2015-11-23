class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/OiNutter/nodenv"
  url "https://github.com/OiNutter/nodenv/archive/v0.4.0.tar.gz"
  sha256 "bfbfb9de2177cf2418baf367b08e929459027cb8979419db7602929cb10e73bd"
  head "https://github.com/OiNutter/nodenv.git"

  bottle :unneeded

  depends_on "node-build" => :recommended

  def install
    inreplace "libexec/nodenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "libexec", "completions"
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.nodenv add to your profile:
      export NODENV_ROOT=#{var}/nodenv

    To enable shims and autocompletion add to your profile:
      if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/nodenv init -)\" && nodenv --version")
  end
end
