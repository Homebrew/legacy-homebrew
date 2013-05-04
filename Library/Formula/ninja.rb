require 'formula'

class Ninja < Formula
  homepage 'https://github.com/martine/ninja'
  url 'https://github.com/martine/ninja/archive/v1.1.0.tar.gz'
  sha1 'ce37677326997c70da4fe49c1e948aba5b77317f'

  def install
    system "./bootstrap.py"
    bin.install "ninja"
    bash_completion.install 'misc/bash-completion' => 'ninja-completion.sh'
  end
end
