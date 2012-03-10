require 'formula'

class Duply < Formula
  url 'http://sourceforge.net/projects/ftplicity/files/duply%20(simple%20duplicity)/1.5.x/duply_1.5.4.tgz'
  homepage 'http://duply.net'
  md5 '07ca9266d2abec31f2aa19e23f912dac'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
