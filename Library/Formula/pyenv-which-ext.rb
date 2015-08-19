class PyenvWhichExt < Formula
  desc "Integrate pyenv and system commands"
  homepage "https://github.com/yyuu/pyenv-which-ext"
  url "https://github.com/yyuu/pyenv-which-ext/archive/v0.0.2.tar.gz"
  sha256 "4098e5a96b048192b0eab66ca5f588602e30ed16aac816e96ff514f6b5896257"

  head "https://github.com/yyuu/pyenv-which-ext.git"

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv which python")
  end
end
