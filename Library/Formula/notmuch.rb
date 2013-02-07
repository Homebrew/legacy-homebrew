require 'formula'

class Notmuch < Formula
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.13.2.tar.gz'
  sha1 '368b2451a64b1e3c574e688100700fc941ff2ea1'

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
