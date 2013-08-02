require 'formula'

class Duply < Formula
  homepage 'http://duply.net'
  url 'http://downloads.sourceforge.net/project/ftplicity/duply%20(simple%20duplicity)/1.5.x/duply_1.5.10.tgz'
  sha1 '01db7ac0d884ff643ee6a51d6ac81f9270b7a76b'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
