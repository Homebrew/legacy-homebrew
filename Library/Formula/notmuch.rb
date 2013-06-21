require 'formula'

class NewEnoughEmacs < Requirement
  fatal true

  def satisfied?
    `emacs --version`.split("\n")[0] =~ /GNU Emacs (\d+)\./
    major_version = ($1 || 0).to_i
    major_version >= 23
  end

  def message
    "Emacs support requires at least Emacs 23."
  end
end

class Notmuch < Formula
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.15.2.tar.gz'
  sha1 'cbfcfe8441dded2268da2740eb7da4c509c289bb'

  option "emacs", "Install emacs support."

  depends_on NewEnoughEmacs if build.include? "emacs"
  depends_on 'pkg-config' => :build
  depends_on 'xapian'
  depends_on 'talloc'
  depends_on 'gmime'

  fails_with :clang do
    cause "./lib/notmuch-private.h:478:8: error: visibility does not match previous declaration"
  end

  def install
    args = ["--prefix=#{prefix}"]
    if build.include? "emacs"
      args << "--with-emacs"
    else
      args << "--without-emacs"
    end
    system "./configure", *args

    if ARGV.verbose?
      system "make install V=1"
    else
      system "make install"
    end
  end
end
