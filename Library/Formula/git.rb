require 'formula'

class Git < Formula
  homepage 'http://git-scm.com'
  url 'http://git-core.googlecode.com/files/git-1.8.4.2.tar.gz'
  sha1 'f2e9317703553b4215700605c15d0f3a30623a9d'
  head 'https://github.com/git/git.git'

  bottle do
    sha1 '028a2d04720decebabc8a7a9e47121ab95e967be' => :mavericks
    sha1 '7b3d19e95c10c66a927928e18fe83c9fbd53eb04' => :mountain_lion
    sha1 '826fae4c92d82d7e87ad7a4f543d5eb503b31440' => :lion
  end

  option 'with-blk-sha1', 'Compile with the block-optimized SHA1 implementation'
  option 'without-completions', 'Disable bash/zsh completions from "contrib" directory'
  option 'with-brewed-openssl', "Build with Homebrew OpenSSL instead of the system version"
  option 'with-brewed-curl', "Use Homebrew's version of cURL library"

  depends_on :python
  depends_on 'pcre' => :optional
  depends_on 'gettext' => :optional
  depends_on 'openssl' if build.with? 'brewed-openssl'
  depends_on 'curl' => 'with-darwinssl' if build.with? 'brewed-curl'

  resource 'man' do
    url 'http://git-core.googlecode.com/files/git-manpages-1.8.4.2.tar.gz'
    sha1 'aebbb6dc8bca979f8d54bdef51b128deba195c94'
  end

  resource 'html' do
    url 'http://git-core.googlecode.com/files/git-htmldocs-1.8.4.2.tar.gz'
    sha1 'b0d5e7e24aba1af4a8e1a4fa9c894c3a673bf5d8'
  end

  def install
    # If these things are installed, tell Git build system to not use them
    ENV['NO_FINK'] = '1'
    ENV['NO_DARWIN_PORTS'] = '1'
    ENV['V'] = '1' # build verbosely
    ENV['NO_R_TO_GCC_LINKER'] = '1' # pass arguments to LD correctly
    ENV['PYTHON_PATH'] = python.binary if python
    ENV['PERL_PATH'] = which 'perl'

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

    # Make html docs world-readable; check if this is still needed at 1.8.4.2
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
