require 'formula'

class GitManuals < Formula
  url 'http://git-core.googlecode.com/files/git-manpages-1.7.11.1.tar.gz'
  sha1 'e2defbf75ff15d7684d70457e41bc45fb22f0e1f'
end

class GitHtmldocs < Formula
  url 'http://git-core.googlecode.com/files/git-htmldocs-1.7.11.1.tar.gz'
  sha1 'f7d288033a508f673824a52bc21073232e7c9736'
end

class Git < Formula
  homepage 'http://git-scm.com'
  url 'http://git-core.googlecode.com/files/git-1.7.11.1.tar.gz'
  sha1 'd09664978931d215e43241689eb09371b509c7ce'

  head 'https://github.com/git/git.git'

  depends_on 'pcre' if ARGV.include? '--with-pcre'

  def options
    [
      ['--with-blk-sha1', 'compile with the optimized SHA1 implementation'],
      ['--with-pcre', 'compile with the PCRE library'],
    ]
  end

  def install
    # If these things are installed, tell Git build system to not use them
    ENV['NO_FINK'] = '1'
    ENV['NO_DARWIN_PORTS'] = '1'
    ENV['V'] = '1' # build verbosely
    ENV['NO_R_TO_GCC_LINKER'] = '1' # pass arguments to LD correctly
    ENV['NO_GETTEXT'] = '1'
    ENV['PERL_PATH'] = which 'perl' # workaround for users of perlbrew
    ENV['PYTHON_PATH'] = which 'python' # python can be brewed or unbrewed

    # Clean XCode 4.x installs don't include Perl MakeMaker
    ENV['NO_PERL_MAKEMAKER'] = '1' if MacOS.lion?

    ENV['BLK_SHA1'] = '1' if ARGV.include? '--with-blk-sha1'

    if ARGV.include? '--with-pcre'
      ENV['USE_LIBPCRE'] = '1'
      ENV['LIBPCREDIR'] = HOMEBREW_PREFIX
    end

    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"

    # Install the OS X keychain credential helper
    cd 'contrib/credential/osxkeychain' do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install 'git-credential-osxkeychain'
      system "make", "clean"
    end

    # install the completion script first because it is inside 'contrib'
    (prefix+'etc/bash_completion.d').install 'contrib/completion/git-completion.bash'
    (share+'git-core').install 'contrib'

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    GitManuals.new.brew { man.install Dir['*'] }
    GitHtmldocs.new.brew { (share+'doc/git-doc').install Dir['*'] }
  end

  def caveats; <<-EOS.undent
    Bash completion has been installed to:
      #{etc}/bash_completion.d

    The OS X keychain credential helper has been installed to:
      #{HOMEBREW_PREFIX}/bin/git-credential-osxkeychain

    The 'contrib' directory has been installed to:
      #{HOMEBREW_PREFIX}/share/git-core/contrib
    EOS
  end

  def test
    HOMEBREW_REPOSITORY.cd do
      `#{bin}/git ls-files -- bin`.chomp == 'bin/brew'
    end
  end
end
