require "formula"

class PyenvVirtualenv < Formula
  homepage "https://github.com/yyuu/pyenv-virtualenv"
  url "https://github.com/yyuu/pyenv-virtualenv/archive/v20140615.tar.gz"
  sha1 "ba753592f2dcb4d2ef0d65b1622672d5defc50c0"

  head "https://github.com/yyuu/pyenv-virtualenv.git"

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  def caveats; <<-EOS.undent
    To enable auto-activation add to your profile:
      if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
    EOS
  end
end
