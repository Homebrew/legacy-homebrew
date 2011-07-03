require 'formula'

class Gitslave < Formula
  url 'http://downloads.sourceforge.net/project/gitslave/gitslave-2.0.1.tar.gz'
  homepage 'http://gitslave.sourceforge.net'
  md5 '7fed63110ae1a656af10462f60592000'

  # depends_on 'cmake'

  def install
    system "make install -C contrib"
  end
end
