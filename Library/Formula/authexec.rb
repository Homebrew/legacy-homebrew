require 'formula'

class Authexec < Formula
  homepage 'https://github.com/tcurdt/authexec'
  url 'https://github.com/tcurdt/authexec/tarball/1.0'
  head 'https://github.com/tcurdt/authexec.git'
  md5 '3ee6c6939be0372b3c1fdaa73d762387'

  def install
    system 'make all'
    bin.install 'authexec'
  end
end
