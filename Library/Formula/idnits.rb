require 'formula'

class Idnits <Formula
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.02.tgz'
  homepage 'http://tools.ietf.org/tools/idnits/'
  md5 '9570404dc6fad568e289ca6eeac76b6f'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install %w(about todo)
  end
end
