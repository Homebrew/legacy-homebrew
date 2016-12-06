require 'formula'

class Rhash < Formula
  homepage 'http://rhash.anz.ru/'
  url 'http://downloads.sourceforge.net/project/rhash/rhash/1.2.9/rhash-1.2.9-src.tar.gz'
  md5 '1b4b41709790e715b20b647891cf6211'

  def install
    system 'make', 'install', "PREFIX=#{prefix}", "DESTDIR=#{prefix}", "CC=#{ENV.cc}"
  end
end
