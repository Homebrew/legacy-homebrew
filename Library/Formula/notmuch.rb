require 'formula'

class Notmuch < Formula
  url 'http://notmuchmail.org/releases/notmuch-0.5.tar.gz'
  homepage 'http://notmuchmail.org'
  md5 '983cd907a7bf5ee0d12ebfb54cff784f'

  depends_on 'xapian'
  depends_on 'talloc'
  depends_on 'gmime'

  def install
    system "./configure", "--prefix=#{prefix}"

    # notmuch requires a newer emacs than macosx provides. So we either
    # disable the emacs bindings or make notmuch depend on the homebrew
    # emacs package.
    # And there is a race condition in the makefile, so we have to either
    # deparallelize the process or run make and make install separately.

    system "make HAVE_EMACS=0"
    system "make install HAVE_EMACS=0"
  end
end
