require 'formula'

class ClassDump < Formula
  homepage 'http://www.codethecode.com/projects/class-dump/'
  url 'http://www.codethecode.com/download/class-dump-3.4.tar.bz2'
  sha1 'bc6d9542af201028ae980b9d0497b491ce98227f'

  head 'https://github.com/nygard/class-dump.git'

  skip_clean "bin/class-dump"

  def install
    bin.install 'class-dump'
  end
end
