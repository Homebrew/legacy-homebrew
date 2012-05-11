require 'formula'

class Bbcp < Formula
  homepage 'http://www.slac.stanford.edu/%7Eabh/bbcp'
  url 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.tgz'
  version "10.08.29.00.0"
  md5 '1ed7e42aa6b9233bcc1ef8567c4bc7f9'

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
