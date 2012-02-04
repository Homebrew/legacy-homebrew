require 'formula'

class Vcprompt < Formula
  head 'git://github.com/xvzf/vcprompt.git'
  homepage 'https://github.com/xvzf/vcprompt'

  def install
    system "python setup.py build"
    # Install manually; 'make install' doesn't work.
    bin.install "bin/vcprompt"
  end
end

