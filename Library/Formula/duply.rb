require 'formula'

class Duply < Formula
  homepage 'http://duply.net'
  url 'http://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/1.5.x/duply_1.5.8.tgz'
  sha1 '0b8925fc34a51642b752e550cf57a044c61bfa57'

  depends_on 'duplicity'

  def install
    bin.install 'duply'
  end
end
