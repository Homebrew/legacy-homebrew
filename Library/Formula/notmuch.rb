require 'formula'

class Notmuch < Formula
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.11.tar.gz'
  sha1 '11eb1d967af089ed36f6816f61ebae308bc19339'

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
