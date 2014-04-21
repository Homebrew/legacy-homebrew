require "formula"

class PyenvVirtualenv < Formula
  homepage "https://github.com/yyuu/pyenv-virtualenv"
  url "https://github.com/yyuu/pyenv-virtualenv/archive/v20140421.tar.gz"
  sha1 "65a82ec70a1de8995d4238fd23becd152e25bdcf"

  head "https://github.com/yyuu/pyenv-virtualenv.git"

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end
end
