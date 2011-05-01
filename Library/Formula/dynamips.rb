require 'formula'

class Dynamips <Formula
  url 'http://www.ipflow.utc.fr/dynamips/dynamips-0.2.8-RC2.tar.gz'
  homepage 'http://www.ipflow.utc.fr/index.php/Cisco_7200_Simulator'
  md5 '8d12d28684d164fe3312a3fe43c84d2e'

  depends_on 'libelf'

  def install
    system "make install"
  end
end
