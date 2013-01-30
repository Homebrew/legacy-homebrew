require 'formula'

class Notmuch < Formula
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.15.1.tar.gz'
  sha1 '09eb29b8a80c2c5bb3e9d91b4946cfd0dc93e608'

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
    ENV.j1
    system "make install"
  end
end
