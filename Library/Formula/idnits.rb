require 'formula'

class Idnits < Formula
  homepage 'http://tools.ietf.org/tools/idnits/'
  url 'http://tools.ietf.org/tools/idnits/idnits-2.13.02.tgz'
  sha1 'ade1681c8a970fa176d293028f444aac099e9950'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install_metafiles
  end
end
