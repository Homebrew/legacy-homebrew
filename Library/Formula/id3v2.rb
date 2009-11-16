require 'formula'

class Id3v2 <Formula
  url 'http://prdownloads.sourceforge.net/id3v2/id3v2-0.1.11.tar.gz'
  homepage 'http://id3v2.sourceforge.net/'
  md5 '68afc3827cf01501dfb22949f901f1d8'

  depends_on 'id3lib'

  def install
    inreplace 'Makefile', 'c++', '$(CXX)'
    FileUtils.mkdir_p "#{prefix}/bin"
    FileUtils.mkdir_p "#{prefix}/man/man1"
    system "make install PREFIX=#{prefix}"
  end
end
