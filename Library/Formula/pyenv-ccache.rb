require "formula"

class PyenvCcache < Formula
  homepage "https://github.com/yyuu/pyenv-ccache"
  url "https://github.com/yyuu/pyenv-ccache/archive/v0.0.2.tar.gz"
  sha1 "bd68c92315c5aa8e2d596981f0fab31e6c366137"

  head "https://github.com/yyuu/pyenv-ccache.git"

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end
end
