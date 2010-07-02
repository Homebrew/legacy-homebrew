require 'formula'

class Idnits <Formula
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.04.tgz'
  homepage 'http://tools.ietf.org/tools/idnits/'
  md5 'a86757d52438f053592b8ec816f53914'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install %w(about todo)
  end
end
