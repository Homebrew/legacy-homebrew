require 'formula'

class Talloc <Formula
  url 'http://samba.org/ftp/talloc/talloc-2.0.1.tar.gz'
  homepage 'http://talloc.samba.org/'
  md5 'c6e736540145ca58cb3dcb42f91cf57b'

  def install
    system "./configure", "--prefix=#{prefix}"

    # See https://bugzilla.samba.org/show_bug.cgi?id=7000
    # It seems that the patch included there is not enough
    inreplace 'Makefile', 'SONAMEFLAG = #', 'SONAMEFLAG = -install_name'

    system "make install"
  end
end
