require 'formula'

class Opws <Formula
  url 'https://github.com/mbacarella/opws/tarball/40400d944afc767381bd1777f6fe6789b962613e'
  version '40400d9'
  homepage 'https://github.com/mbacarella/opws'
  md5 '4ba459506de99dd8d360e026868904e0'
  head 'https://github.com/mbacarella/opws.git'

  depends_on 'objective-caml'

  def install
    system "make"
    system "mkdir -p #{prefix}/bin"
    system "cp opws #{prefix}/bin"
  end
end
