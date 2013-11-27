require 'formula'

class Git < Formula
  homepage 'http://git-scm.com'
  url 'http://git-core.googlecode.com/files/git-1.8.4.3.tar.gz'
  sha1 '43b1edc95b3ab77f9739d789b906ded0585fe7a2'
  head 'https://github.com/git/git.git'

  bottle do
    revision 1
    sha1 'b30e3fbe6b8e4e3307c96b5924378ad302deb5ab' => :mavericks
    sha1 '17d2cde9690251789672218a52113cfa8a702560' => :mountain_lion
    sha1 'b5a0da40e046f706dc303cc853b8466e81e081ba' => :lion
  end

  option 'with-blk-sha1', 'Compile with the block-optimized SHA1 implementation'
  option 'without-completions', 'Disable bash/zsh completions from "contrib" directory'
  option 'with-brewed-openssl', "Build with Homebrew OpenSSL instead of the system version"
  option 'with-brewed-curl', "Use Homebrew's version of cURL library"
  option 'with-persistent-https', 'Build git-remote-persistent-https from "contrib" directory'

  depends_on :python
  depends_on 'pcre' => :optional
  depends_on 'gettext' => :optional
  depends_on 'openssl' if build.with? 'brewed-openssl'
  depends_on 'curl' => 'with-darwinssl' if build.with? 'brewed-curl'
  depends_on 'go' => :build if build.with? 'persistent-https'

  resource 'man' do
    url 'http://git-core.googlecode.com/files/git-manpages-1.8.4.3.tar.gz'
    sha1 '3a7e9322a95e0743b902152083366fe97f322ab1'
  end

  resource 'html' do
    url 'http://git-core.googlecode.com/files/git-htmldocs-1.8.4.3.tar.gz'
    sha1 'eb4eb4991464f44deda19d1435d9721146587661'
  end

  def patches
    if MacOS.version >= :mavericks
      # Allow using PERLLIB_EXTRA to find Subversion Perl bindings location
      # in the CLT/Xcode. Should be included in Git 1.8.6.
      # https://git.kernel.org/cgit/git/git.git/commit/?h=next&id=07981d
      # https://git.kernel.org/cgit/git/git.git/commit/?h=next&id=0386dd
      ['https://git.kernel.org/cgit/git/git.git/patch/?id=07981d',
       'https://git.kernel.org/cgit/git/git.git/patch/?id=0386dd']
    end
  end

  def install
    # If these things are installed, tell Git build system to not use them
    ENV['NO_FINK'] = '1'
    ENV['NO_DARWIN_PORTS'] = '1'
    ENV['V'] = '1' # build verbosely
    ENV['NO_R_TO_GCC_LINKER'] = '1' # pass arguments to LD correctly
    ENV['PYTHON_PATH'] = python.binary if python
    ENV['PERL_PATH'] = which 'perl'

    if MacOS.version >= :mavericks and MacOS.dev_tools_prefix
      ENV['PERLLIB_EXTRA'] = "#{MacOS.dev_tools_prefix}/Library/Perl/5.16/darwin-thread-multi-2level"
    end

    unless quiet_system ENV['PERL_PATH'], '-e', 'use ExtUtils::MakeMaker'
      ENV['NO_PERL_MAKEMAKER'] = '1'
    end

    ENV['BLK_SHA1'] = '1' if build.with? 'blk-sha1'

    if build.with? 'pcre'
      ENV['USE_LIBPCRE'] = '1'
      ENV['LIBPCREDIR'] = Formula.factory('pcre').opt_prefix
    end

    ENV['NO_GETTEXT'] = '1' unless build.with? 'gettext'

    system "make", "prefix=#{prefix}",
                   "sysconfdir=#{etc}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"

    if OS.mac?
        # Install the OS X keychain credential helper
        cd 'contrib/credential/osxkeychain' do
          system "make", "CC=#{ENV.cc}",
                         "CFLAGS=#{ENV.cflags}",
                         "LDFLAGS=#{ENV.ldflags}"
          bin.install 'git-credential-osxkeychain'
          system "make", "clean"
        end
    end

    # Install git-subtree
    cd 'contrib/subtree' do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install 'git-subtree'
    end

    if build.with? 'persistent-https'
      cd 'contrib/persistent-https' do
        system "make"
        bin.install 'git-remote-persistent-http',
                    'git-remote-persistent-https',
                    'git-remote-persistent-https--proxy'
      end
    end

    unless build.without? 'completions'
      # install the completion script first because it is inside 'contrib'
      bash_completion.install 'contrib/completion/git-completion.bash'
      bash_completion.install 'contrib/completion/git-prompt.sh'

      zsh_completion.install 'contrib/completion/git-completion.zsh' => '_git'
      cp "#{bash_completion}/git-completion.bash", zsh_completion
    end

    (share+'git-core').install 'contrib'

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource('man')
    (share+'doc/git-doc').install resource('html')

    # Make html docs world-readable; check if this is still needed at 1.8.4.4
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
  end

  def caveats; <<-EOS.undent
    The OS X keychain credential helper has been installed to:
      #{HOMEBREW_PREFIX}/bin/git-credential-osxkeychain

    The 'contrib' directory has been installed to:
      #{HOMEBREW_PREFIX}/share/git-core/contrib
    EOS
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal 'bin/brew', `#{bin}/git ls-files -- bin`.strip
    end
  end
end
