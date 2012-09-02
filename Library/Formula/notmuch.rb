require 'formula'

class Notmuch < Formula
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.13.2.tar.gz'
  sha1 '368b2451a64b1e3c574e688100700fc941ff2ea1'
  head 'git://notmuchmail.org/git/notmuch'

  depends_on 'xapian'
  depends_on 'talloc'
  depends_on 'gmime'

  def options
    [
     ['--without-emacs', "Don't install Emacs interface"],
    ]
  end

  def patches
    if not ARGV.include? "--without-emacs"
      [
       # the following two patches are needed to compile notmuch's emacs interface
       # with emacs22, which is shipped by default on OSX
       "https://gist.github.com/raw/3139011/984ec8c398a562aa097edbb7af5179bb6988bf66/Json.el%20patch",
       "https://gist.github.com/raw/3139182/6eadcf59be88cc8102dc380ecc00a4ea6d078e6e/declare-function-patch"
      ]
    end
  end

  def install

    args = ["--prefix=#{prefix}"]
    if ARGV.include? "--without-emacs"
      args << "--without-emacs"
    end

    system "./configure", *args
    system "make install"
    system "install_name_tool", "-change", "libnotmuch.3.dylib", "#{lib}/libnotmuch.3.dylib", "#{bin}/notmuch"
  end
end
