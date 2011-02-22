require 'formula'

class Idnits <Formula
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.07.tgz'
  homepage 'http://tools.ietf.org/tools/idnits/'
  md5 '5fa4476b6e821f650b1f4b52575fb1a3'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install %w(about todo)
  end
end
