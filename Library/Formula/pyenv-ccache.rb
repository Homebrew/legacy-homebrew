class PyenvCcache < Formula
  desc "Make Python build faster, using the leverage of `ccache`"
  homepage "https://github.com/yyuu/pyenv-ccache"
  url "https://github.com/yyuu/pyenv-ccache/archive/v0.0.2.tar.gz"
  sha256 "ebfb8a5ed754df485b3f391078c5dc913f0587791a5e3815e61078f0db180b9e"

  head "https://github.com/yyuu/pyenv-ccache.git"

  depends_on "pyenv"
  depends_on "ccache" => :recommended

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    assert shell_output("eval \"$(pyenv init -)\" && pyenv hooks install").include?("ccache.bash")
  end
end
