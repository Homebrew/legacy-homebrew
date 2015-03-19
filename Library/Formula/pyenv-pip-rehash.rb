class PyenvPipRehash < Formula
  homepage "https://github.com/yyuu/pyenv-pip-rehash"
  url "https://github.com/yyuu/pyenv-pip-rehash/archive/v0.0.4.tar.gz"
  sha256 "ea61e859425d1330a6683dc2962f9974021381ca78871ab3a15c2cc442c00593"

  head "https://github.com/yyuu/pyenv-pip-rehash.git"

  depends_on "pyenv"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    assert shell_output("pyenv hooks exec").include?("pip.bash")
  end
end
