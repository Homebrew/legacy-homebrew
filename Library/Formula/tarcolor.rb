require 'formula'

class Tarcolor < Formula
  homepage 'https://github.com/msabramo/tarcolor'
  head 'https://github.com/msabramo/tarcolor.git'
  url 'https://github.com/downloads/msabramo/tarcolor/App-TarColor-0.004.tar.gz'
  md5 '9a25357f898a791f5a2fa1f4985973eb'

  def install
    system "pod2man bin/tarcolor tarcolor.1"
    man1.install 'tarcolor.1'
    man1.install 'etc/tarcolorauto.1'
    bin.install 'bin/tarcolor'
    (prefix+'etc/tarcolor').install 'etc/tarcolorauto.sh'
    (prefix+'t').install "t/test.t"
  end

  def test
    cd prefix do
      system "t/test.t"
    end
  end
end
