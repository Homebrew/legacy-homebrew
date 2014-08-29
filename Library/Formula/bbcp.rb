require 'formula'

class Bbcp < Formula
  homepage 'http://www.slac.stanford.edu/%7Eabh/bbcp'
  url 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.git'
  version '14.04.14.00.1'
  head 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.git'

  def install
    mkdir %w{bin obj}
    system "make", "-C", "src", "Darwin"
    bin.install "bin/bbcp"
  end

  test do
    system "#{bin}/bbcp", "--help"
  end
end
