require 'formula'

class Vcprompt < Formula
  head 'hg://http://vc.gerg.ca/hg/vcprompt/'
  homepage 'http://vc.gerg.ca/hg/vcprompt/'

  def install
    system "make"
    # Install manually; 'make install' doesn't work.
    bin.install "vcprompt"
  end
end

