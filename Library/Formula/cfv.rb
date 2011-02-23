require 'formula'

class Cfv <Formula
  url 'http://downloads.sourceforge.net/project/cfv/cfv/1.18.3/cfv-1.18.3.tar.gz'
  homepage 'http://cfv.sourceforge.net/'
  md5 '1be9039c2ab859103d70b6c4f4e5edf5'

  def install
    system "make prefix=#{prefix} mandir=#{prefix}/share/man install"
  end
end
