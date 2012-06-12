require 'formula'

class Id3v2 < Formula
  url 'http://downloads.sourceforge.net/project/id3v2/id3v2/0.1.12/id3v2-0.1.12.tar.gz'
  homepage 'http://id3v2.sourceforge.net/'
  md5 'be91b4a41710b3a926e913a24ba0ed3b'

  depends_on 'id3lib'

  def install
    inreplace 'Makefile' do |s|
      # don't pre-format man page
      s.gsub! 'nroff -man id3v2.1 >', "install -c id3v2.1"
    end

    bin.mkpath
    man1.mkpath
    # remove binaries mistakenly left in tarball
    system "make", "clean"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
