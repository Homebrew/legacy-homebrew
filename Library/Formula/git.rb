require 'formula'

class GitManuals < Formula
  url 'http://git-core.googlecode.com/files/git-manpages-1.7.9.tar.gz'
  sha1 '1ca1fc430b2814f9e9cf82ec3bf7f2eaf5209b7a'
end

class GitHtmldocs < Formula
  url 'http://git-core.googlecode.com/files/git-htmldocs-1.7.9.tar.gz'
  sha1 'c7b1fa20dc501beb2cb5091dd24dbfd2a0013a0c'
end

class Git < Formula
  url 'http://git-core.googlecode.com/files/git-1.7.9.tar.gz'
  sha1 'ed51ef5ef250daaa6e98515cf2641820cd268d4c'
  homepage 'http://git-scm.com'

  depends_on 'pcre' if ARGV.include? '--with-pcre'

  def options
    [
      ['--with-blk-sha1', 'compile with the optimized SHA1 implementation'],
      ['--with-pcre', 'compile with the PCRE library'],
    ]
  end

  def install
    # If these things are installed, tell Git build system to not use them
    ENV['NO_FINK']='1'
    ENV['NO_DARWIN_PORTS']='1'
    ENV['V']='1' # build verbosely
    ENV['NO_R_TO_GCC_LINKER']='1' # pass arguments to LD correctly
    ENV['NO_GETTEXT']= '1'
    # workaround for users of perlbrew
    ENV['PERL_PATH'] = `/usr/bin/which perl`.chomp

    # Clean XCode 4.x installs don't include Perl MakeMaker
    ENV['NO_PERL_MAKEMAKER']='1' if MacOS.lion?

    ENV['BLK_SHA1']='1' if ARGV.include? '--with-blk-sha1'

    if ARGV.include? '--with-pcre'
      ENV['USE_LIBPCRE']='1'
      ENV['LIBPCREDIR'] = HOMEBREW_PREFIX
    end

    inreplace "Makefile" do |s|
      s.remove_make_var! %w{CC CFLAGS LDFLAGS}
    end

    system "make", "prefix=#{prefix}", "install"

    # Install the Git bash completion file.
    # Put it into the Cellar so that it gets upgraded along with git upgrades.
    (prefix+'etc/bash_completion.d').install 'contrib/completion/git-completion.bash'

    # Install emacs support.
    (share+'doc/git-core/contrib').install 'contrib/emacs'
    # Some people like the stuff in the contrib folder
    (share+'git').install 'contrib'

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
