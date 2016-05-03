class PyenvVirtualenv < Formula
  desc "Pyenv plugin to manage virtualenv"
  homepage "https://github.com/yyuu/pyenv-virtualenv"
  url "https://github.com/yyuu/pyenv-virtualenv/archive/v20160202.tar.gz"
  sha256 "7a5c419949c9bedd8fb427c8bf2b8b88ed42536c25265f60078e4af666787de9"
  head "https://github.com/yyuu/pyenv-virtualenv.git"

  bottle :unneeded

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  def caveats; <<-EOS.undent
    To enable auto-activation add to your profile:
      command -v pyenv-virtualenv-init>/dev/null 2>&1 && {eval "$(pyenv virtualenv-init -)";}
    EOS
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvs")
  end
end
