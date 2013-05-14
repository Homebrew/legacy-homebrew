require 'formula'

class Id3v2 < Formula
  homepage 'http://id3v2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/id3v2/id3v2/0.1.12/id3v2-0.1.12.tar.gz'
  sha1 '8f42153b2f53098c221da2e8fe42170e727cd9ad'

  depends_on 'id3lib'

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end
end
