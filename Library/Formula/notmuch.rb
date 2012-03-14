require 'formula'

class Notmuch < Formula
<<<<<<< HEAD
   url 'http://notmuchmail.org/releases/notmuch-0.11.1.tar.gz'
   sha1 '05694ae8762076bf91d63b199e72a12e5ce012b0'
   homepage 'http://notmuchmail.org'
=======
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.11.tar.gz'
  sha1 '11eb1d967af089ed36f6816f61ebae308bc19339'
>>>>>>> a4926b84c2b4ef7b0777e679a88d4c44f0fa20a7

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
