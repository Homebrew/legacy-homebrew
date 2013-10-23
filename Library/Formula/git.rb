require 'formula'

class Git < Formula
  homepage 'http://git-scm.com'
  url 'http://git-core.googlecode.com/files/git-1.8.4.1.tar.gz'
  sha1 '49004a8dfcbb7c0848147737d9877fd7313a42ec'
  head 'https://github.com/git/git.git'

  bottle do
    sha1 'bd2613ef7c911b2dbde23defa6a61faaaca43290' => :mountain_lion
    sha1 'd85ad2d80d2006a1058cb63916061116acbc104f' => :lion
    sha1 '6ca4e8bb250eb97f709b9f05c7230bd0cce9aca2' => :snow_leopard
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
    url 'http://git-core.googlecode.com/files/git-manpages-1.8.4.1.tar.gz'
    sha1 'dc0f9de1cacc8912f131b67dc5a19a96768ecc95'
  end

  resource 'html' do
    url 'http://git-core.googlecode.com/files/git-htmldocs-1.8.4.1.tar.gz'
    sha1 '1f0e5c5934ec333b5630a8c93a0fb0b1895dfcb8'
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

    # Install the OS X keychain credential helper
    cd 'contrib/credential/osxkeychain' do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install 'git-credential-osxkeychain'
      system "make", "clean"
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
