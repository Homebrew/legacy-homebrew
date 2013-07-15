require 'formula'

class Snobol4 < Formula
  homepage 'http://www.snobol4.org/'
  url 'ftp://ftp.ultimate.com/snobol/snobol4-1.4.1.tar.gz'
  sha1 'bfff40320b75fef507b463eacdf7c74a2e448f72'

  def install
    system './configure', "--prefix=#{prefix}", "--mandir=#{man}"
    system 'make install'
  end
end
