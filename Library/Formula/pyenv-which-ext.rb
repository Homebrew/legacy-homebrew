require "formula"

class PyenvWhichExt < Formula
  homepage "https://github.com/yyuu/pyenv-which-ext"
  url "https://github.com/yyuu/pyenv-which-ext/archive/v0.0.2.tar.gz"
  sha1 "72d2d3a80d6d9226276dfb897d12f7be69a12f0a"

  head "https://github.com/yyuu/pyenv-which-ext.git"

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end
end
