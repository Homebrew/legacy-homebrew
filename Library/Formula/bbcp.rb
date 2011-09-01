require 'formula'

class Bbcp < Formula
  url 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.tgz'
  homepage 'http://www.slac.stanford.edu/%7Eabh/bbcp'
  md5 '1ed7e42aa6b9233bcc1ef8567c4bc7f9'
  version "10.08.29.00.0"

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
