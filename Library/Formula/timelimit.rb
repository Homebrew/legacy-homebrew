require 'formula'
require 'etc' # for uid and gid

class Timelimit < Formula
  homepage 'http://devel.ringlet.net/sysutils/timelimit/'
  url 'http://devel.ringlet.net/sysutils/timelimit/timelimit-1.8.tar.gz'
  sha1 '0bc20606db0f587f3927f747680c9522b2d4c5af'

  def install
    pwuid = Etc.getpwuid
    user = pwuid.name
    group = Etc.getgrgid(pwuid.gid).name
    system  "make LOCALBASE=#{prefix} BINOWN=#{user} BINGRP=#{group} MANOWN=#{user} MANGRP=#{group} MANDIR=#{man}/man install"
  end

  def test
    system 'time timelimit -T 30 ls'
  end
end
