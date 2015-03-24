class Git < Formula
  homepage "http://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.3.4.tar.gz"
  sha256 "49c9c840a0a53f77e01830f0737a69dc56be0fa1a3d5cc1bacc56da4dd3a442b"

  head "https://github.com/git/git.git", :shallow => false

  bottle do
    sha256 "e756df7030a334e84899c51f61878a0ee85e38e48d32f086ec6a1d3e6836a7ad" => :yosemite
    sha256 "d6e43e90e364641996171cccc718f54557264fbd4ade02ec6e26f7a57e3f410a" => :mavericks
    sha256 "08ee7c699793198b168fa4c509147ce664e5dcf36adc8daa1fd8454aedff3f65" => :mountain_lion
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.3.4.tar.gz"
    sha256 "34954257dfbd0cd6db579c17c8c2049c03e0e7dcc9be26f76a61b91011d80fa5"
  end

  resource "html" do
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.3.4.tar.gz"
    sha256 "1002b976257423ad9b203736fb5a1f50ca9a3b5dde38b9a0b8751a71e707b939"
  end

  option "with-blk-sha1", "Compile with the block-optimized SHA1 implementation"
  option "without-completions", "Disable bash/zsh completions from 'contrib' directory"
  option "with-brewed-openssl", "Build with Homebrew OpenSSL instead of the system version"
  option "with-brewed-curl", "Use Homebrew's version of cURL library"
  option "with-brewed-svn", "Use Homebrew's version of SVN"
  option "with-persistent-https", "Build git-remote-persistent-https from 'contrib' directory"

  depends_on "pcre" => :optional
  depends_on "gettext" => :optional
  depends_on "openssl" if build.with? "brewed-openssl"
  depends_on "curl" if build.with? "brewed-curl"
  depends_on "go" => :build if build.with? "persistent-https"
  # Trigger an install of swig before subversion, as the "swig" doesn't get pulled in otherwise
  # See https://github.com/Homebrew/homebrew/issues/34554
  if build.with? "brewed-svn"
    depends_on "swig"
    depends_on "subversion" => "with-perl"
  end

  def install
    # If these things are installed, tell Git build system to not use them
    ENV["NO_FINK"] = "1"
    ENV["NO_DARWIN_PORTS"] = "1"
    ENV["V"] = "1" # build verbosely
    ENV["NO_R_TO_GCC_LINKER"] = "1" # pass arguments to LD correctly
    ENV["PYTHON_PATH"] = which "python"
    ENV["PERL_PATH"] = which "perl"

    perl_version = /\d\.\d+/.match(`perl --version`)

    if build.with? "brewed-svn"
      ENV["PERLLIB_EXTRA"] = "#{Formula["subversion"].prefix}/Library/Perl/#{perl_version}/darwin-thread-multi-2level"
    elsif MacOS.version >= :mavericks
      ENV["PERLLIB_EXTRA"] = %W{
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      }.uniq.map { |p|
        "#{p}/Library/Perl/#{perl_version}/darwin-thread-multi-2level"
      }.join(":")
    end

    unless quiet_system ENV["PERL_PATH"], "-e", "use ExtUtils::MakeMaker"
      ENV["NO_PERL_MAKEMAKER"] = "1"
    end

    ENV["BLK_SHA1"] = "1" if build.with? "blk-sha1"

    if build.with? "pcre"
      ENV["USE_LIBPCRE"] = "1"
      ENV["LIBPCREDIR"] = Formula["pcre"].opt_prefix
    end

    ENV["NO_GETTEXT"] = "1" if build.without? "gettext"

    system "make", "prefix=#{prefix}",
                   "sysconfdir=#{etc}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"

    # Install the OS X keychain credential helper
    cd "contrib/credential/osxkeychain" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install "git-credential-osxkeychain"
      system "make", "clean"
    end

    # Install git-subtree
    cd "contrib/subtree" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install "git-subtree"
    end

    if build.with? "persistent-https"
      cd "contrib/persistent-https" do
        system "make"
        bin.install "git-remote-persistent-http",
                    "git-remote-persistent-https",
                    "git-remote-persistent-https--proxy"
      end
    end

    if build.with? "completions"
      # install the completion script first because it is inside "contrib"
      bash_completion.install "contrib/completion/git-completion.bash"
      bash_completion.install "contrib/completion/git-prompt.sh"

      zsh_completion.install "contrib/completion/git-completion.zsh" => "_git"
      cp "#{bash_completion}/git-completion.bash", zsh_completion
    end

    (share+"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share+"doc/git-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]

    # To avoid this feature hooking into the system OpenSSL, remove it.
    # If you need it, install git --with-brewed-openssl.
    rm "#{libexec}/git-core/git-imap-send" if build.without? "brewed-openssl"
  end

  def caveats; <<-EOS.undent
    The OS X keychain credential helper has been installed to:
      #{HOMEBREW_PREFIX}/bin/git-credential-osxkeychain

    The "contrib" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/git-core/contrib
    EOS
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal "bin/brew", `#{bin}/git ls-files -- bin`.strip
    end
  end
end
