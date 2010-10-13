require 'formula'

class Idnits <Formula
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.05.tgz'
  homepage 'http://tools.ietf.org/tools/idnits/'
  md5 'd2d56588d3202c10757f74770316426c'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install %w(about todo)
  end
end
