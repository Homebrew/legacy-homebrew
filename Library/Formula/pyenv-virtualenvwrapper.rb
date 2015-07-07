class PyenvVirtualenvwrapper < Formula
  desc "Alternative to pyenv for managing virtualenvs"
  homepage "https://github.com/yyuu/pyenv-virtualenvwrapper"
  url "https://github.com/yyuu/pyenv-virtualenvwrapper/archive/v20140609.tar.gz"
  sha1 "04c36c836cbf1284f9d3bb5c442f40712022b532"

  head "https://github.com/yyuu/pyenv-virtualenvwrapper.git"

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    shell_output("eval \"$(pyenv init -)\" && pyenv virtualenvwrapper")
  end
end
