require 'formula'

class Cntlm <Formula
  version "0.35.1"
  #url 'http://svn.awk.cz/cntlm/tags/release-0.35.1/', :using => :svn
  url 'http://sourceforge.net/projects/cntlm/files/cntlm/cntlm%200.35.1/cntlm-0.35.1.tar.gz/download'
  homepage 'http://sourceforge.net/projects/cntlm/'
  md5 '2547c73a1159062fdaa1877cc03a22f6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install ['cntlm']
    etc.install ['doc/cntlm.conf']
    man1.install ['doc/cntlm.1']
    ohai ""
    opoo "Edit your default proxy configuration in #{etc}/cntlm.conf to configure Cntlm"
    ohai ""
  end
end
