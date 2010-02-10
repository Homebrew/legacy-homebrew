require 'formula'

class Idnits <Formula
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.00.tgz'
  homepage 'http://tools.ietf.org/tools/idnits/'
  md5 '54a4bbcf6e9afa454d608afa60cc7e5b'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    doc.install %w(about changelog copyright todo)
  end
end
