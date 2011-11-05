require 'formula'

class Notmuch < Formula
  url 'http://notmuchmail.org/releases/notmuch-0.9.tar.gz'
  homepage 'http://notmuchmail.org'
  sha1 '988e93545880e9465380383f00d591d8a23c61dd'

  depends_on 'xapian'
  depends_on 'talloc'
  depends_on 'gmime'

  def install
    system "./configure", "--prefix=#{prefix}", "--without-emacs"

    # notmuch requires a newer emacs than macosx provides. So we either
    # disable the emacs bindings or make notmuch depend on the homebrew
    # emacs package.
    # And there is a race condition in the makefile, so we have to either
    # deparallelize the process or run make and make install separately.

    system "make"
    system "make install"
  end
end
