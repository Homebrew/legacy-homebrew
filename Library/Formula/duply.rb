require 'formula'

class Duply < Formula
  homepage 'http://duply.net'
  url 'http://downloads.sourceforge.net/project/ftplicity/duply%20(simple%20duplicity)/1.5.x/duply_1.5.11.tgz'
  sha1 '73381c1d49de37aeb8594994bae4db2b687c8f8a'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
