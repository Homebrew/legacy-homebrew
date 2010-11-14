require 'formula'

class Aiccu <Formula
  url 'http://www.sixxs.net/archive/sixxs/aiccu/unix/aiccu_20070115.tar.gz'
  homepage 'http://www.sixxs.net/tools/aiccu/'
  md5 'c9bcc83644ed788e22a7c3f3d4021350'

  depends_on 'tuntap'

  def install
    inreplace 'Makefile' do |s| 
      s.change_make_var! "DESTDIR", "#{prefix}"
      s.change_make_var! "dirsbin", "/sbin/"
    end
    
    system "make all"
    system "make install"
    
    (prefix+"etc").install "doc/aiccu.conf"
    system "ln",prefix+"etc/aiccu.conf","/etc/aiccu.conf"
  end
  
  def caveats
    "Please run aiccu sudo'd!\nYour aiccu.conf is located in #{HOMEBREW_PREFIX}/etc/aiccu.conf"
  end
  
end
