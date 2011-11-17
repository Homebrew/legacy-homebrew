require 'formula'

class GitManuals < Formula
  url 'http://git-core.googlecode.com/files/git-manpages-1.7.7.3.tar.gz'
  sha1 'cf1b0d35e2d242bc4cffce3b2bf5b3e32857b395'
end

class GitHtmldocs < Formula
  url 'http://git-core.googlecode.com/files/git-htmldocs-1.7.7.3.tar.gz'
  sha1 'bc0f89cb04e562e4a6d3b936382dbc8f593d861f'
end

class Git < Formula
  url 'http://git-core.googlecode.com/files/git-1.7.7.3.tar.gz'
  sha1 '382ee40da74a1b4a1875820c0f0a35c9ccd750f8'
  homepage 'http://git-scm.com'

  def options
    [['--with-blk-sha1', 'compile with the optimized SHA1 implementation']]
  end

  def patches; DATA; end

  def install
    # If these things are installed, tell Git build system to not use them
    ENV['NO_FINK']='1'
    ENV['NO_DARWIN_PORTS']='1'
    ENV['V']='1' # build verbosely

    # Clean XCode 4.x installs don't include Perl MakeMaker
    ENV['NO_PERL_MAKEMAKER']='1' if MacOS.lion?

    ENV['BLK_SHA1']='1' if ARGV.include? '--with-blk-sha1'

    inreplace "Makefile" do |s|
      s.remove_make_var! %w{CFLAGS LDFLAGS}
    end

    system "make", "prefix=#{prefix}", "install"

    # Install the Git bash completion file.
    # Put it into the Cellar so that it gets upgraded along with git upgrades.
    (prefix+'etc/bash_completion.d').install 'contrib/completion/git-completion.bash'

    # Install emacs support.
    (share+'doc/git-core/contrib').install 'contrib/emacs'
    # Some people like the stuff in the contrib folder
    (share+'git').install 'contrib'

    # These files are exact copies of the git binary, so like the contents
    # of libexec/git-core lets hard link them.
    # I am assuming this is an overisght by the git devs.
    git_md5 = (bin+'git').md5
    %w[git-receive-pack git-upload-archive].each do |fn|
      fn = bin + fn
      next unless git_md5 == fn.md5
      fn.unlink
      fn.make_link bin+'git'
    end

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    GitManuals.new.brew { man.install Dir['*'] }
    GitHtmldocs.new.brew { (share+'doc/git-doc').install Dir['*'] }
  end

  def caveats; <<-EOS.undent
    Bash completion has been installed to:
      #{etc}/bash_completion.d

    Emacs support has been installed to:
      #{HOMEBREW_PREFIX}/share/doc/git-core/contrib/emacs

    The rest of the "contrib" is installed to:
      #{HOMEBREW_PREFIX}/share/git/contrib
    EOS
  end
end
__END__
diff -urN git-1.7.7.3.orig/perl/Makefile git-1.7.7.3/perl/Makefile
--- git-1.7.7.3.orig/perl/Makefile	2011-11-08 20:05:09.000000000 -0500
+++ git-1.7.7.3/perl/Makefile	2011-11-16 23:41:27.000000000 -0500
@@ -20,7 +20,7 @@
 	$(RM) $(makfile).old
 
 ifdef NO_PERL_MAKEMAKER
-instdir_SQ = $(subst ','\'',$(prefix)/lib)
+instdir_SQ = $(subst installsitelib=,'',$(shell $(PERL_PATH_SQ) -V:installsitelib))
 $(makfile): ../GIT-CFLAGS Makefile
 	echo all: private-Error.pm Git.pm > $@
 	echo '	mkdir -p blib/lib' >> $@
