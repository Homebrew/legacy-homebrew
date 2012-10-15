require 'formula'

class Rfcdiff < Formula
  url 'http://tools.ietf.org/tools/rfcdiff/rfcdiff-1.41.tgz'
  homepage 'http://tools.ietf.org/tools/rfcdiff/'
  sha1 '02bcd3bf6078caec001bf677530c97893edf34a1'

  depends_on 'wdiff'
  depends_on 'gawk' => :recommended

  def install
    bin.install "rfcdiff"
    prefix.install "todo"
  end
end
