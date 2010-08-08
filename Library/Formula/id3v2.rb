require 'formula'

class Id3v2 <Formula
  url 'http://downloads.sourceforge.net/project/id3v2/id3v2/0.1.11/id3v2-0.1.11.tar.gz'
  homepage 'http://id3v2.sourceforge.net/'
  md5 '68afc3827cf01501dfb22949f901f1d8'

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
