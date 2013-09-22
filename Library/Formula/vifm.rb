require 'formula'

class Vifm < Formula
  homepage 'http://vifm.sourceforge.net/index.html'
  url 'http://downloads.sourceforge.net/project/vifm/vifm/vifm-0.7.5.tar.bz2'
  sha1 '202b369b45d741e32a50084d902c4dcc33014915'

  # This actually depends on Xcode 4.2 or newer, not Lion per se, as it will
  # work on Snow Leopard running Xcode 4.2. This software uses the string
  # functions `wcscasecmp` and `wcsncasecmp`, which were not present in
  # earlier compiler sets.
  # Note that someone could add implementations of these to str.c in this
  # software and likely get it to compile across versions, if someone had the
  # energy to attempt this.
  depends_on :macos => :lion

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
