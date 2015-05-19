require 'formula'

class Icon < Formula
  desc "General-purpose programming language"
  homepage 'http://www.cs.arizona.edu/icon/'
  url 'http://www.cs.arizona.edu/icon/ftp/packages/unix/icon-v951src.tgz'
  sha1 '21b122e3b4abf75a9248d0c52b9fa06899ac97fb'
  version '9.5.1'

  def install
    ENV.deparallelize
    system 'make', 'Configure', 'name=posix'
    system 'make'
    bin.install 'bin/icon', 'bin/icont', 'bin/iconx'
    doc.install Dir['doc/*']
    man1.install Dir['man/man1/*.1']
  end
end
