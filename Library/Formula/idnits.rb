require 'formula'

class Idnits < Formula
  url 'http://tools.ietf.org/tools/idnits/idnits-2.12.13.tgz'
  homepage 'http://tools.ietf.org/tools/idnits/'
  md5 '7ceb18f416eefbab5bbd4c30b75f2145'

  depends_on 'aspell'

  def install
    bin.install "idnits"
    prefix.install %w(about todo)
  end
end
