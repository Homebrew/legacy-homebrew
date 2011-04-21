require 'formula'

class Notmuch < Formula
  version '0.5'
  url 'http://notmuchmail.org/releases/notmuch-0.5.tar.gz'
  head 'git://notmuchmail.org/git/notmuch', :using => :git
  homepage 'http://notmuchmail.org/'

  depends_on 'xapian'
  depends_on 'gmime'
  depends_on 'talloc'
  depends_on 'emacs'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
