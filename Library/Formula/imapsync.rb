require 'formula'

class Imapsync < Formula
  url 'https://fedorahosted.org/released/imapsync/imapsync-1.456.tgz'
  homepage 'http://ks.lamiral.info/imapsync/'
  md5 'e9ea9ab5eba11cfe1c62ae9be1d9d7ae'

  depends_on 'Mail::IMAPClient' => :perl
  depends_on 'Authen::NTLM'     => :perl

  def install
    system 'perl', '-c', 'imapsync'
    system 'pod2man', 'imapsync', 'imapsync.1'
    bin.install 'imapsync'
    man1.install 'imapsync.1'
  end

end
