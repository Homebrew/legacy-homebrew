require 'formula'

class Djview4 <Formula
  url 'http://sourceforge.net/projects/djvu/files/DjView/4.6/djview4-4.6.tar.gz'
  homepage 'http://djvu.sourceforge.net/djview4.html'
  md5 '642105970467cf0864c0073140d1fa11'

  depends_on 'djvulibre'
  depends_on 'qt'

  def install
    # Added bug upstream to fix this:
    # https://sourceforge.net/tracker/?func=detail&aid=3146507&group_id=32953&atid=406583
    inreplace "Makefile.in" do |s|
       s.gsub! '${INSTALL_PROGRAM} src/djview ${DESTDIR}${bindir}/djview4', '/bin/cp -r src/djview.app ${DESTDIR}${prefix}'
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-desktopfiles"
    system "make"
    system "make install"
    # Remove bad symlink created by make install
    bin.rmtree
  end

  def caveats; <<-EOS
    djview.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
  end
end
