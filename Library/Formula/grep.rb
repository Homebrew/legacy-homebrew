require 'formula'

class Grep <Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'http://mirror.its.uidaho.edu/pub/gnu/grep/grep-2.5.4.tar.bz2'
  md5 '5650ee2ae6ea4b39e9459d7d0585b315'

  depends_on 'gettext'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-nls",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"

    # Configure gives me 2 copies of -lpcre and no -lintl, so fix that
    inreplace "src/Makefile" do |s|
      s.change_make_var! "LIBS", "-lintl -lpcre"
    end

    system "make"
    system "make install"
  end
end
