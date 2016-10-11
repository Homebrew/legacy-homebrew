require 'formula'

class Autoconf213 <Formula
  url 'http://ftp.gnu.org/pub/gnu/autoconf/autoconf-2.13.tar.gz'
  md5 '9de56d4a161a723228220b0f425dc711'
  homepage 'http://www.gnu.org/software/autoconf/'

  def keg_only?
    :provided_by_osx
  end

  def install
    inreplace 'configure', 'for ac_prog in mawk gawk nawk awk', 'for ac_prog in awk'

    system "./configure", "--disable-debug", 
                          "--program-suffix=213",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--datadir=#{prefix}/share/autoconf213"
    system "make install"
  end
end