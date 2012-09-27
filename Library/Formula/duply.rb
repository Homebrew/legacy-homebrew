require 'formula'

class Duply < Formula
  homepage 'http://duply.net'
  url 'http://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/1.5.x/duply_1.5.7.tgz'
  sha1 '61d5e17285d2645e818c8449e4fd8d149edf9b9e'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
