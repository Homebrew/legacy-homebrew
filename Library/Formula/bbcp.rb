require 'formula'

class Bbcp < Formula
  homepage 'http://www.slac.stanford.edu/%7Eabh/bbcp'
  url 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.tgz'
  version '13.05.03.00.0'
  sha1 '218911904b46f7aff3784705581737f53eccbc53'

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
