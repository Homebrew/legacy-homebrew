require 'formula'

class Notmuch < Formula
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.13.2.tar.gz'
  sha1 '368b2451a64b1e3c574e688100700fc941ff2ea1'

  depends_on 'xapian'
  depends_on 'talloc'
  depends_on 'gmime'

  def install
    # requires a newer emacs than OS X provides, so disable the bindings
    system "./configure", "--prefix=#{prefix}", "--without-emacs"
    system "make install"
    system "install_name_tool", "-change", "libnotmuch.2.dylib",
                                "#{lib}/libnotmuch.2.dylib", "#{bin}/notmuch"
  end
end
