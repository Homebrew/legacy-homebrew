require 'formula'

class TProt <Formula
  url 'http://www.escape.de/~tolot/mutt/t-prot/downloads/t-prot-2.101.tar.gz'
  homepage 'http://www.escape.de/~tolot/mutt/'
  md5 '9c2bec775c230b7532d0a4e17972d271'

  depends_on 'Getopt::Long' => :perl

  def install
    bin.install 't-prot'
    man1.install 't-prot.1'
    (share + "doc/#{name}-#{version}").install Dir['*']
  end
end
