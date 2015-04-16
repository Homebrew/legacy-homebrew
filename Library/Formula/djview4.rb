require 'formula'

class Djview4 < Formula
  homepage 'http://djvu.sourceforge.net/djview4.html'
  url 'https://downloads.sourceforge.net/project/djvu/DjView/4.10/djview-4.10.3.tar.gz'
  sha1 '5e31fec525d05744454bd0b74f0375acde1ad66c'

  depends_on 'pkg-config' => :build
  depends_on 'djvulibre'
  depends_on 'qt'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-nsdejavu",
                          "--disable-desktopfiles"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"

    # From the djview4.8 README:
    # Note3: Do not use command "make install".
    # Simply copy the application bundle where you want it.
    prefix.install 'src/djview.app'
  end
end
