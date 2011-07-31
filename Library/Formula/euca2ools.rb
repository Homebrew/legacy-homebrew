require 'formula'

class Euca2ools < Formula
  url 'http://open.eucalyptus.com/sites/all/modules/pubdlcnt/pubdlcnt.php?file=http://eucalyptussoftware.com/downloads/releases/euca2ools-1.3.1.tar.gz'
  homepage 'http://open.eucalyptus.com/downloads'
  md5 'a835e8fabd5875a5c8dbcba1bf89d402'

  depends_on 'help2man'
  depends_on 'euca2ools-deps'

  def install
    system "make"
  end
end
