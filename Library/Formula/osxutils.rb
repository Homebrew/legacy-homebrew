require 'formula'

class Osxutils < Formula
  homepage 'https://github.com/vasi/osxutils'
  url 'git://github.com/vasi/osxutils.git', :revision => '118ab690f1cc63289f56ebcfbe6c90dff1edb7cb'
  version '1.7-118ab690f1'
  head 'git://github.com/vasi/osxutils.git'
  
  def install
    system 'make'
    system 'make', "PREFIX=#{prefix}", 'install'
  end
  
  def test
    execs_test = %w[google rcmac setvolume wiki]
    execs_test.each {|e| system 'test', bin/e}
    execs_test.each {|e| system 'test', e}
    execs_run = %w[cpath fileinfo getfcomment geticon hfsdata lsmac mkalias osxutils setfcomment setfctypes setfflags seticon setlabel setsuffix trash wsupdate]
    execs_run.each {|e| system bin/e, '-h'}
    execs_run.each {|e| system e, '-h'}
  end
end
