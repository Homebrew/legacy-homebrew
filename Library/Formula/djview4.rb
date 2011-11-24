require 'formula'

class Djview4 < Formula
  url 'http://sourceforge.net/projects/djvu/files/DjView/4.8/djview-4.8.tar.gz'
  homepage 'http://djvu.sourceforge.net/djview4.html'
  md5 '70ef8f416c7d6892cc0cf012bfd0ae07'

  depends_on 'pkg-config' => :build
  depends_on 'djvulibre'
  depends_on 'qt'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-desktopfiles"
    system "make"

    # From the djview4.8 README:
    #     Note3: Do not use command "make install".
    #     Simply copy the application bundle where you want it.
    prefix.install 'src/djview.app'
  end

  def caveats; <<-EOS
    djview.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
  end
end
