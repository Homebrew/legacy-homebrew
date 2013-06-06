require 'formula'

class Duply < Formula
  homepage 'http://duply.net'
  url 'http://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/1.5.x/duply_1.5.10.tgz'
  sha1 '01db7ac0d884ff643ee6a51d6ac81f9270b7a76b'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
