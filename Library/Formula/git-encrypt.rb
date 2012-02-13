require 'formula'

class GitEncrypt < Formula
  version "HEAD"
  url 'git://github.com/shadowhand/git-encrypt.git'
  homepage 'https://github.com/shadowhand/git-encrypt'
  md5 ''

  def install
    print "Symlink the file from #{prefix}"
    bin.mkpath
    bin.install ['gitcrypt']
  end

  def test
    # this will fail we won't accept that, make it test the program works!
    system "/usr/bin/false"
  end
end

