require 'formula'

class Notmuch < Formula
  homepage 'http://notmuchmail.org'
  url 'http://notmuchmail.org/releases/notmuch-0.11.tar.gz'
  sha1 '11eb1d967af089ed36f6816f61ebae308bc19339'

  depends_on 'xapian'
  depends_on 'talloc'
  depends_on 'gmime'

  # notmuch elisp interface requires a newer emacs than OS X provides.
  # unless the user specifies to use Emacs.app or Aquamacs.app, we don't provide elisp interface
  def options
    [
      ['--use-aquamacs', "Use Aquamacs.app to build the lisp interface"],
      ['--use-emacsapp', "Use Emacs.app to build the lisp interface"],
      ['--use-emacsbrew', "Use Emacs.app installed by Homebrew"],
    ]
  end

  def install

    if ARGV.include? "--use-emacsbrew"
      emacs_prefix = Formula.factory('emacs').prefix
      emacs = "#{emacs_prefix}/Emacs.app/Contents/MacOS/Emacs"
    elsif ARGV.include? "--use-aquamacs"
      emacs = "/Applications/Aquamacs.app/Contents/MacOS/Aquamacs"
    elsif ARGV.include? "--use-emacsapp"
      emacs = "/Applications/Emacs.app/Contents/MacOS/Emacs"
    end

    args = ["--prefix=#{prefix}"]
    unless emacs.nil?
      inreplace 'configure', 'EMACS = emacs --quick', "EMACS = #{emacs} --quick"
    else
      args << "--without-emacs"
    end

    system "./configure", *args
    system "make install"
    system "install_name_tool", "-change", "libnotmuch.2.dylib",
                                "#{lib}/libnotmuch.2.dylib", "#{bin}/notmuch"
  end
end
