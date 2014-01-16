require 'formula'

class Duply < Formula
  homepage 'http://duply.net'
  url 'http://downloads.sourceforge.net/project/ftplicity/duply%20(simple%20duplicity)/1.6.x/duply_1.6.0.tgz'
  sha1 '0e376c331b26b64cf1d537b3d9f417eac393fd92'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
