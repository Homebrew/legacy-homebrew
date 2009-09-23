require 'brewkit'

class Frotz <Formula
  @url='http://downloads.sourceforge.net/project/frotz/frotz/2.43/frotz-2.43.tar.gz'
  @homepage='http://frotz.sourceforge.net/'
  @md5='efe51879e012b92bb8d5f4a82e982677'

  def install
    inreplace "Makefile", "CC = gcc", ""
    inreplace "Makefile", "OPTS = -O2", ""
    inreplace "Makefile", "PREFIX = /usr/local", "PREFIX = #{prefix}"
    inreplace "Makefile", "CONFIG_DIR = /usr/local/etc", ""

    system "make frotz"
    system "make install"
  end
end
