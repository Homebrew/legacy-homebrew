require 'formula'

class Since < Formula
  url 'http://welz.org.za/projects/since/since-1.1.tar.gz'
  homepage 'http://welz.org.za/projects/since'
  md5 '7a6cfe573d0d2ec7b6f53fe9432a486b'

  def install
    system "make"
    bin.install "since"
    man1.install "since.1"
  end
end
