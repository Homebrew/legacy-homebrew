require 'formula'

class Bbcp < Formula
  url 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.git'
  homepage 'http://www.slac.stanford.edu/%7Eabh/bbcp'
  version '14.04.14.00.1'

  def install
    Dir.mkdir "bin"
    Dir.mkdir "obj"
    cd "src" do
      system "make", "Darwin"
    end
    bin.install "bin/bbcp"
  end

  def test
    system("#{bin}/bbcp","--help")
  end
end
