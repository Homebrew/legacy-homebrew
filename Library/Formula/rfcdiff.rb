require 'formula'

class Rfcdiff <Formula
  url 'http://tools.ietf.org/tools/rfcdiff/rfcdiff-1.38.tgz'
  homepage 'http://tools.ietf.org/tools/rfcdiff/'
  md5 '127e724c8263e10ed74a2f74705930cb'

  depends_on 'wdiff'
  depends_on 'gawk' => :recommended

  def install
    bin.install "rfcdiff"
    prefix.install "todo"
  end
end
