require 'formula'

class Tcpsplit < Formula
  desc "Break a packet trace into some number of sub-traces"
  homepage 'http://www.icir.org/mallman/software/tcpsplit/'
  url 'http://www.icir.org/mallman/software/tcpsplit/tcpsplit-0.2.tar.gz'
  sha1 '0d63392c4960078911b5716d74e4a7426f149a09'

  def install
    system 'make'
    bin.install 'tcpsplit'
  end
end
