require 'formula'

class Idnits < Formula
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.11.tgz'
  homepage 'http://tools.ietf.org/tools/idnits/'
  md5 '8ec3c5bac662407df42495e5d8e93512'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install %w(about todo)
  end
end
