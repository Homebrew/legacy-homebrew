require 'formula'

class Unrar < Formula
  homepage 'http://www.rarlab.com'
  url 'http://www.rarlab.com/rar/unrarsrc-4.2.4.tar.gz'
  sha1 '1cc29603fb4e4df16a3aa9bfc7da1afaf0923259'

  devel do
    url 'http://www.rarlab.com/rar/unrarsrc-5.0.10.tar.gz'
    sha1 'd48c245a58193c373fd2633f40829dcdda33b387'
  end

  def install

    if build.stable?
      system "make --makefile makefile.unix"
    else
      system "make"
    end

    bin.install 'unrar'
    prefix.install 'license.txt' => 'COPYING'
    prefix.install 'readme.txt' => 'README'
  end
end
