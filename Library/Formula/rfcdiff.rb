require 'formula'

class Rfcdiff < Formula
  url 'http://tools.ietf.org/tools/rfcdiff/rfcdiff-1.40.tgz'
  homepage 'http://tools.ietf.org/tools/rfcdiff/'
  md5 '9b29508e080edbc329e959620502b19b'

  depends_on 'wdiff'
  depends_on 'gawk' => :recommended

  def install
    bin.install "rfcdiff"
    prefix.install "todo"
  end
end
