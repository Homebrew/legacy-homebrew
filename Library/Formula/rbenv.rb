class Rbenv < Formula
  desc "Ruby environment tool"
  homepage "https://github.com/sstephenson/rbenv"
  url "https://github.com/sstephenson/rbenv/archive/v0.4.0.tar.gz"
  sha256 "d40fe637cc799b828498fc5793548fab70d9e2431efc6a3d3f4a671d670fa9ff"

  head "https://github.com/sstephenson/rbenv.git"

  def install
    inreplace "libexec/rbenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.rbenv add to your profile:
      export RBENV_ROOT=#{var}/rbenv

    To enable shims and autocompletion add to your profile:
      if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions")
  end
end
