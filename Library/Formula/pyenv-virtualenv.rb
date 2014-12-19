require "formula"

class PyenvVirtualenv < Formula
  homepage "https://github.com/yyuu/pyenv-virtualenv"
  url "https://github.com/yyuu/pyenv-virtualenv/archive/v20141012.tar.gz"
  sha1 "171c547d669eea0f00bd9c8ba75b42b4b8794a79"

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
