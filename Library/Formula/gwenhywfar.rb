require 'formula'

class Gwenhywfar < Formula
  homepage 'http://www.aqbanking.de/'
  url 'http://www.aquamaniac.de/sites/download/download.php?package=01&release=67&file=01&dummy=gwenhywfar-4.3.3.tar.gz'
  sha1 'c2ba4c45f1eeb379db6c2ae09122c592893f3bd0'
  head 'http://devel.aqbanking.de/svn/gwenhywfar/trunk'
  revision 2

  devel do
    url 'http://www2.aquamaniac.de/sites/download/download.php?package=01&release=76&file=01&dummy=gwenhywfar-4.12.0beta.tar.gz'
    sha1 '02fe19f12970cf94c495ba78a99f492f0a9067b0'
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'gtk+' => :optional
  depends_on 'qt' => :optional

  option 'without-cocoa', 'Build without cocoa support'

  def install
    guis = []
    guis << "gtk2" if build.with? "gtk+"
    guis << "qt4" if build.with? "qt"
    guis << "cocoa" if build.with? "cocoa"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=#{guis.join(' ')}"
    system "make install"
  end
end
