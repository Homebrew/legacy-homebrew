require 'formula'

class Duply < Formula
  homepage 'http://duply.net'
  url 'http://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/1.5.x/duply_1.5.9.tgz'
  sha1 '5b9277b3f20ff88cfb045069580b6a3e9d382c83'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
