require 'formula'

class Since < Formula
  homepage 'http://welz.org.za/projects/since'
  url 'http://welz.org.za/projects/since/since-1.1.tar.gz'
  sha1 '67f07e8237d63f846cd8ca60b5a16fc32d4f81a5'

  def install
    system "make"
    bin.install "since"
    man1.install "since.1"
  end
end
