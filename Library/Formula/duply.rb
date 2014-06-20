require 'formula'

class Duply < Formula
  homepage 'http://duply.net'
  url 'https://downloads.sourceforge.net/project/ftplicity/duply%20(simple%20duplicity)/1.7.x/duply_1.7.3.tgz'
  sha1 'f9111e1cfee4cd63a38ff153735d35ca3956aa21'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
