require 'formula'

class Reaver < Formula
  homepage 'http://code.google.com/p/reaver-wps/'
  url 'https://reaver-wps.googlecode.com/files/reaver-1.4.tar.gz'
  sha1 '2ebec75c3979daa7b576bc54adedc60eb0e27a21'

  # Adds general support for Mac OS X in reaver:
  # http://code.google.com/p/reaver-wps/issues/detail?id=245
  patch do
    url "https://gist.githubusercontent.com/syndicut/6134996/raw/16f1b4336c104375ff93a88858809eced53c1171/reaver-osx.diff"
    sha1 "9b5c77a167fdc34627a7ff3e15f8e5b5a67226a4"
  end

  def install
    man1.install 'docs/reaver.1.gz'
    prefix.install_metafiles 'docs'
    cd "src"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    system "make install"
  end
end
