require 'formula'

class Git < Formula
  homepage "http://git-scm.com"
  head "https://github.com/git/git.git", :shallow => false

  stable do
    url "https://www.kernel.org/pub/software/scm/git/git-1.9.3.tar.gz"
    sha1 "8306305c4d39ac4fc07c9cf343241f12f7b69df2"

    resource "man" do
      url "https://www.kernel.org/pub/software/scm/git/git-manpages-1.9.3.tar.gz"
      sha1 "88f4ef546eddad6a78496426c46a7e63fb53349a"
    end

    resource "html" do
      url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-1.9.3.tar.gz"
      sha1 "ee7c4dbdeef99b048a4c314ce3186c94ff80a928"
    end
  end

  bottle do
    revision 1
    sha1 "1dc48e195c5ba69da02f2852745c491f29798f2e" => :mavericks
    sha1 "f5b7f25814befcfdfb27a3aa70d71877ff9c38f4" => :mountain_lion
    sha1 "da54997466f4d49b1448160ef3cabe52c1c6bf71" => :lion
  end

  devel do
    version "2.0.0.rc3"
    url "https://www.kernel.org/pub/software/scm/git/testing/git-2.0.0.rc3.tar.gz"
    sha1 "ec5ad54c1461ad1b59d4093f7eeb43ad1c041bb1"

    resource "man" do
      url "https://www.kernel.org/pub/software/scm/git/testing/git-manpages-2.0.0.rc3.tar.gz"
      sha1 "c1ed66e64c907a389e743f16200ccc0d53051ca8"
    end

    resource "html" do
      url "https://www.kernel.org/pub/software/scm/git/testing/git-htmldocs-2.0.0.rc3.tar.gz"
      sha1 "5e5a8374b36d2b794ecd5bfb648e0f16c0236ca5"
    end
  end

  option 'with-blk-sha1', 'Compile with the block-optimized SHA1 implementation'
  option 'without-completions', 'Disable bash/zsh completions from "contrib" directory'
  option 'with-brewed-openssl', "Build with Homebrew OpenSSL instead of the system version"
  option 'with-brewed-curl', "Use Homebrew's version of cURL library"
  option 'with-persistent-https', 'Build git-remote-persistent-https from "contrib" directory'

  depends_on 'pcre' => :optional
  depends_on 'gettext' => :optional
  depends_on 'openssl' if build.with? 'brewed-openssl'
  depends_on 'curl' if build.with? 'brewed-curl'
  depends_on 'go' => :build if build.with? 'persistent-https'

  def install
    # If these things are installed, tell Git build system to not use them
    ENV['NO_FINK'] = '1'
    ENV['NO_DARWIN_PORTS'] = '1'
    ENV['V'] = '1' # build verbosely
    ENV['NO_R_TO_GCC_LINKER'] = '1' # pass arguments to LD correctly
    ENV['PYTHON_PATH'] = which 'python'
    ENV['PERL_PATH'] = which 'perl'

    if MacOS.version >= :mavericks
      ENV["PERLLIB_EXTRA"] = %W{
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      }.uniq.map { |p|
        "#{p}/Library/Perl/5.16/darwin-thread-multi-2level"
      }.join(":")
    end

    unless quiet_system ENV['PERL_PATH'], '-e', 'use ExtUtils::MakeMaker'
      ENV['NO_PERL_MAKEMAKER'] = '1'
    end

    ENV['BLK_SHA1'] = '1' if build.with? 'blk-sha1'

    if build.with? 'pcre'
      ENV['USE_LIBPCRE'] = '1'
      ENV['LIBPCREDIR'] = Formula['pcre'].opt_prefix
    end

    ENV['NO_GETTEXT'] = '1' if build.without? 'gettext'

    ENV['GIT_DIR'] = cached_download/".git" if build.head?

    system "make", "prefix=#{prefix}",
                   "sysconfdir=#{etc}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"

    bin.install Dir["contrib/remote-helpers/git-remote-{hg,bzr}"]

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

    if build.with? 'persistent-https'
      cd 'contrib/persistent-https' do
        system "make"
        bin.install 'git-remote-persistent-http',
                    'git-remote-persistent-https',
                    'git-remote-persistent-https--proxy'
      end
    end

    if build.with? 'completions'
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

    # Make html docs world-readable; check if this is still needed at 1.8.6
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
