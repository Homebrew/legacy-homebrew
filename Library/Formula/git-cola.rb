require 'formula'

class GitCola < Formula
  url 'http://cola.tuxfamily.org/releases/cola-1.4.3.tar.gz'
  homepage 'http://cola.tuxfamily.org/'
  md5 '64d9c3e45a746c8775a0f33f65b91155'

  depends_on 'pyqt'

  def install
    system "make prefix=#{prefix} install"
  end
end
