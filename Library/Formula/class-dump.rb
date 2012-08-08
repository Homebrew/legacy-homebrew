require 'formula'

class ClassDump < Formula
  homepage 'http://www.codethecode.com/projects/class-dump/'
  url 'http://www.codethecode.com/download/class-dump-3.3.4.tar.bz2'
  sha1 '1e43a3cab522565b0773aab18c40b232f231c46c'

  head 'git://github.com/nygard/class-dump.git'

  skip_clean "bin/class-dump"

  def install
    bin.install 'class-dump'
  end
end
