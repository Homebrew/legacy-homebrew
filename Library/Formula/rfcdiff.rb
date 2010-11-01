require 'formula'

class Rfcdiff <Formula
  url 'http://tools.ietf.org/tools/rfcdiff/rfcdiff-1.39.tgz'
  homepage 'http://tools.ietf.org/tools/rfcdiff/'
  md5 '402f298b64dd0896aa542d09745b58e7'

  depends_on 'wdiff'
  depends_on 'gawk' => :recommended

  def install
    bin.install "rfcdiff"
    prefix.install "todo"
  end
end
