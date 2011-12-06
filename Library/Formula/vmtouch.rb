require 'formula'

class VmtouchManual < Formula
  url 'http://hoytech.com/vmtouch/vmtouch.8'
  version '0.7.3'
  md5 '5586c6a9c79d93acd1a07342ea487a51'
end

class Vmtouch < Formula
  url 'http://hoytech.com/vmtouch/vmtouch.c'
  version '0.7.3'
  homepage 'http://hoytech.com/vmtouch/'
  md5 '575d072ee193784b3e453f90e44cb070'

  def install
    system "/usr/bin/gcc -Wall -O3 -o vmtouch vmtouch.c"
    bin.install 'vmtouch'
    
    # Technique for installing manpages copied from the git.rb formula
    VmtouchManual.new.brew { man8.install Dir['*'] }
  end

  def test
    system vmtouch
  end
end
