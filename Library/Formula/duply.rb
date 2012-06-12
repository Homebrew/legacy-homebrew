require 'formula'

class Duply < Formula
  homepage 'http://duply.net'
  url 'http://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/1.5.x/duply_1.5.5.5.tgz'
  md5 'fdc05d1731dc8d0de88b7e17a1095506'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
