require 'formula'

class Snobol4 < Formula
  desc "SNOBOL4 programming language"
  homepage 'http://www.snobol4.org/'
  url 'ftp://ftp.ultimate.com/snobol/snobol4-1.5.tar.gz'
  sha1 '037a8eeba774b1085cfe8d1a741ec446182e4a9f'

  def install
    system './configure', "--prefix=#{prefix}", "--mandir=#{man}"
    system 'make install'
  end
end
