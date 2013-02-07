require 'formula'

class Notmuch < Formula
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.14.tar.gz'
  sha1 'ad1ef9c2d29cfb0faab7837968d11325dee404bd'

  depends_on 'xapian'
  depends_on 'talloc'
  depends_on 'gmime'

  fails_with :clang do
    build 425
    cause "./lib/notmuch-private.h:478:8: error: visibility does not match previous declaration"
  end

  def install
    # requires a newer emacs than OS X provides, so disable the bindings
    system "./configure", "--prefix=#{prefix}", "--without-emacs"
    system "make install"
  end
end
