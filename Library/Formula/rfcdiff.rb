require 'formula'

class Rfcdiff < Formula
  url 'http://tools.ietf.org/tools/rfcdiff/rfcdiff-1.41.tgz'
  homepage 'http://tools.ietf.org/tools/rfcdiff/'
  md5 'f480e4a571aa39f8e3e788f771568ca8'

  depends_on 'wdiff'
  depends_on 'gawk' => :recommended

  def install
    bin.install "rfcdiff"
    prefix.install "todo"
  end
end
