require 'formula'

class Authexec < Formula
  homepage 'https://github.com/tcurdt/authexec'
  url 'https://github.com/tcurdt/authexec/tarball/1.0'
  sha1 'cae4cbd4c2d3ded8e13b4257d951efd1755ed411'

  head 'https://github.com/tcurdt/authexec.git'

  def install
    system 'make all'
    bin.install 'authexec'
  end
end
