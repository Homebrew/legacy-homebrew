class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v0.4.0.tar.gz"
  sha256 "d40fe637cc799b828498fc5793548fab70d9e2431efc6a3d3f4a671d670fa9ff"
  head "https://github.com/rbenv/rbenv.git"

  bottle :unneeded

  depends_on "ruby-build" => :recommended

  def install
    inreplace "libexec/rbenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    Rbenv stores data under `~/.rbenv' by default. If you absolutely need to instead
    store everything under the Homebrew prefix, include this in your profile:
      export RBENV_ROOT=#{var}/rbenv

    To enable shims and autocompletion, run this and follow the instructions:
      rbenv init
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions")
  end
end
