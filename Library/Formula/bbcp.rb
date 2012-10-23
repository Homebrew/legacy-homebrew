require 'formula'

class Bbcp < Formula
  homepage 'http://www.slac.stanford.edu/%7Eabh/bbcp'
  url 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.tgz'
  version "12.08.17.00.0"
  sha1 '63ada9888f77a07729bfc64bdda124ac44025b51'

  def install
    mkdir "bin"
    mkdir "obj"

    cd "src" do
      system "make", "Darwin"
    end

    bin.install "bin/bbcp"
  end

  def test
    system "#{bin}/bbcp", "--help"
  end
end
