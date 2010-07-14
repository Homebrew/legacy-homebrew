require 'formula'

# Source now available on BitBucket:
# http://bitbucket.org/nygard/class-dump
class ClassDump <Formula
  url 'http://www.codethecode.com/download/class-dump-3.3.2.tar.bz2'
  homepage 'http://www.codethecode.com/projects/class-dump/'
  md5 '070d1a113ed3062512ea08334a85b19c'

  skip_clean "bin/class-dump"

  def install
    bin.install 'class-dump'
  end
end
