require 'formula'

class OrgMode <Formula
  url 'http://orgmode.org/org-7.3.tar.gz'
  homepage 'http://orgmode.org/'
  sha1 'c4b87790f308b99b47a503d9a6ceb51889cc48c4'
  head 'git://repo.or.cz/org-mode.git'

  def options
    [
     ["--with-emacs=/path/to/emacs", "Use the specified emacs to compile org-mode .el files"]
    ]
  end

  def caveats; <<-EOS.undent
    Specify --with-emacs=/path/to/emacs to build with a particular version of
    Emacs (the default is to use whichever 'emacs' is in your path). This is
    useful for building org-mode with a non-system Emacs, e.g., Aquamacs.

    To use this version of org-mode, rather than the one that comes with
    your Emacs, add the following line to your .emacs:

    (setq load-path (cons "#{HOMEBREW_PREFIX}/share/emacs/site-lisp" load-path))

    To activate org-mode, add the following line to your .emacs:

    (require 'org-install)

    To ensure that Emacs sees the org-mode documentation (info files),
    add the following lines to your .emacs:

    (require 'info)
    (info-initialize)
    (setq Info-directory-list (cons "#{HOMEBREW_PREFIX}/share/info" Info-directory-list))

    See here for additional org-mode configuration information:

    http://orgmode.org/manual/Activation.html#Activation
    EOS
  end

  def install
    inreplace 'Makefile', '/usr/local', prefix
    emacs = ARGV.options_only.select {|v| v =~ /--with-emacs=/ }.last
    if emacs
      inreplace 'Makefile', 'EMACS=emacs', 'EMACS='+emacs.split("=")[1]
    end
    system "make install"
    system "make install-info"
  end
end
