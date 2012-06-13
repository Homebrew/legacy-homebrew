require 'formula'

class Rpm2cpio < ScriptFileFormula
  url 'http://www.freebsd.org/cgi/cvsweb.cgi/~checkout~/ports/archivers/rpm2cpio/files/rpm2cpio?rev=1.4'
  homepage 'http://www.freebsd.org/cgi/cvsweb.cgi/ports/archivers/rpm2cpio/'
  md5 '27f19cf1b0b05cfb3256b6b1781378f2'
  version '1.4'
  
  depends_on 'xz'
  
  def install
    bin.install 'rpm2cpio?rev=1.4' => 'rpm2cpio'
  end
end
