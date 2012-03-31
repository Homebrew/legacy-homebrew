require 'formula'

class Tvmet < Formula
  url 'http://downloads.sourceforge.net/project/tvmet/Tar.Gz_Bz2%20Archive/1.7.2/tvmet-1.7.2.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ftvmet%2Ffiles%2F&ts=1333123044&use_mirror=softlayer'
  homepage 'http://tvmet.sourceforge.net'
  md5 '8e1b2ec67ebec65f680a8bd3ea38a656'
  version '1.7.2'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-cppunit"
    system "make" # Separate steps or install fails
    system "make install"
  end
end
