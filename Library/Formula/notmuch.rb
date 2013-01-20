require 'formula'

class Notmuch < Formula
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.13.2.tar.gz'
  sha1 '368b2451a64b1e3c574e688100700fc941ff2ea1'

  def options
    [
     ['--with-emacs', "Compile with (Homebrew) Emacs support"]
    ]
  end

  depends_on 'xapian'
  depends_on 'talloc'
  depends_on 'gmime'

  if ARGV.include? '--with-emacs'
    depends_on 'emacs'
  end

  def install
    if ARGV.include? '--with-emacs'
      system "./configure", "--prefix=#{prefix}"
    else
      # requires a newer emacs than OS X provides, so disable the bindings
      system "./configure", "--prefix=#{prefix}", "--without-emacs"
    end
    system "make install"
  end
end
