require 'formula'

class Talloc < Formula
  url 'http://www.samba.org/ftp/talloc/talloc-2.0.5.tar.gz'
  homepage 'http://talloc.samba.org/'
  md5 '6e3fdfbc43dde8ccba27b6af894b8fb2'

  def install
    system "./configure", "--prefix=#{prefix}"
    # See https://bugzilla.samba.org/show_bug.cgi?id=7000
    # It seems that the patch included there is not enough
    inreplace 'Makefile', 'SONAMEFLAG = #', 'SONAMEFLAG = -install_name'

    system "make install"
  end
end
