require 'formula'

class Osxutils < Formula
  homepage 'https://github.com/vasi/osxutils'
  url 'git://github.com/vasi/osxutils.git', :tag => 'v1.8'
  version '1.8'
  head 'git://github.com/vasi/osxutils.git'
  
  def install
    system 'make'
    system 'make', "PREFIX=#{prefix}", 'install'
  end
  
  def test
    execs_test = %w[google rcmac setvolume wiki]
    execs_test.each {|e| system 'test', bin/e}
    execs_run = %w[cpath fileinfo getfcomment geticon hfsdata lsmac mkalias osxutils setfcomment setfctypes setfflags seticon setlabel setsuffix trash wsupdate]
    execs_run.each {|e| system bin/e, '-h'}
  end
end
