require 'formula'

class Authexec < Formula
  head 'git://github.com/tcurdt/authexec.git'
  homepage 'https://github.com/tcurdt/authexec'

  def install
    system 'make all'
    bin.install 'authexec'
  end
end
