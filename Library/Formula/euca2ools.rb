require 'formula'

class Euca2ools < Formula
  url 'http://open.eucalyptus.com/sites/all/modules/pubdlcnt/pubdlcnt.php?file=http://eucalyptussoftware.com/downloads/releases/euca2ools-1.3.1.tar.gz'
  homepage 'http://open.eucalyptus.com/downloads'
  md5 'a835e8fabd5875a5c8dbcba1bf89d402'

  depends_on 'help2man'
  depends_on 'euca2ools-deps'

  def install
    inreplace 'Makefile' do |s|
      s.gsub! /-o root /, ''
      s.gsub! %r{\$\(PREFIX\)/man}, '$(PREFIX)/share/man'
      (etc+'bash_completion.d').mkpath
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "BASH_COMPLETION", (etc+"bash_completion.d")
    end
    system "make"
  end
end
