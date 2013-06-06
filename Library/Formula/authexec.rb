require 'formula'

class Authexec < Formula
  homepage 'https://github.com/tcurdt/authexec'
  url 'https://github.com/tcurdt/authexec/archive/1.0.tar.gz'
  sha1 '73d8fb4202ae99057691788442bb192972ef304c'

  head 'https://github.com/tcurdt/authexec.git'

  def install
    system 'make all'
    bin.install 'authexec'
  end
end
