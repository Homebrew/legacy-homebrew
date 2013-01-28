require 'formula'

class Id3v2 < Formula
  homepage 'http://id3v2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/id3v2/id3v2/0.1.11/id3v2-0.1.11.tar.gz'
  sha1 'ca825d851ca0c6a5783af107dc6baa7aa93f0bad'

  depends_on 'id3lib'

  def install
    inreplace 'Makefile' do |s|
      s.gsub! 'c++', ENV.cxx
      s.gsub! '/man/man1', '/share/man/man1'
    end

    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end
end
