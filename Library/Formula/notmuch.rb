require 'formula'

class Notmuch < Formula
  version '0.5'
  url 'git://notmuchmail.org/git/notmuch', :using => :git
  homepage 'http://notmuchmail.org/'

  depends_on 'xapian'
  depends_on 'gmime'
  depends_on 'talloc'

  def install
    system "./configure", "--prefix=#{prefix}", "--without-emacs"
    system "make"
    system "make install"
  end
end
