require 'formula'

class Libpng < Formula
  url 'http://downloads.sourceforge.net/project/libpng/libpng15/1.5.4/lpng154.zip'
  homepage 'http://www.ijg.org/'
  sha1 'b4e3ef7d7f8421c42f46aab3f6ace98aeb6e6983'
  version "1.5.4"
  # depends_on 'cmake'

  def install
    system "cp scripts/makefile.linux Makefile"
    system "make prefix=#{prefix} DM=#{man}"	
    system "make install prefix=#{prefix} DM=#{man}"
  end
end


