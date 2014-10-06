require 'formula'

class Git < Formula
  homepage "http://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.1.2.tar.gz"
  sha1 "1385edbc9aa77b6e0971f52f75ba4f2ff35c1aa2"

  head "https://github.com/git/git.git", :shallow => false

  bottle do
    sha1 "3b632bbeccf3a8a9a2b4223d710034657e7d7ea7" => :yosemite
    sha1 "022c2ffe1972adda94e16b58622f699fae76913f" => :mavericks
    sha1 "a39c00a4c6a95a63ed173d88b0b0ba0fe5ef151a" => :mountain_lion
    sha1 "f222f24dd08aaa4a3a678c8660930525d3cd861b" => :lion
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.1.2.tar.gz"
    sha1 "912ff9865d6c6ab3d411566a6805431c7d653efd"
  end

  resource "html" do
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.1.2.tar.gz"
    sha1 "229b697db2c6f7ba0831842849f9dc0651f0fc63"
  end

  option 'with-blk-sha1', 'Compile with the block-optimized SHA1 implementation'
  option 'without-completions', 'Disable bash/zsh completions from "contrib" directory'
  option 'with-brewed-openssl', "Build with Homebrew OpenSSL instead of the system version"
  option 'with-brewed-curl', "Use Homebrew's version of cURL library"
  option 'with-brewed-svn', "Use Homebrew's version of SVN"
  option 'with-persistent-https', 'Build git-remote-persistent-https from "contrib" directory'

  depends_on 'pcre' => :optional
  depends_on 'gettext' => :optional
  depends_on 'openssl' if build.with? 'brewed-openssl'
  depends_on 'curl' if build.with? 'brewed-curl'
  depends_on 'go' => :build if build.with? 'persistent-https'
  depends_on 'subversion' => 'perl' if build.with? 'brewed-svn'

  # This patch fixes Makefile bug contrib/subtree
  # http://thread.gmane.org/gmane.comp.version-control.git/255347
  patch :DATA

  def install
    # If these things are installed, tell Git build system to not use them
    ENV['NO_FINK'] = '1'
    ENV['NO_DARWIN_PORTS'] = '1'
    ENV['V'] = '1' # build verbosely
    ENV['NO_R_TO_GCC_LINKER'] = '1' # pass arguments to LD correctly
    ENV['PYTHON_PATH'] = which 'python'
    ENV['PERL_PATH'] = which 'perl'

    perl_version = /\d\.\d+/.match(`perl --version`)

    if build.with? 'brewed-svn'
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

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]
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

__END__
--- a/contrib/subtree/Makefile
+++ b/contrib/subtree/Makefile
@@ -1,3 +1,5 @@
+all::
+
 -include ../../config.mak.autogen
 -include ../../config.mak
 
@@ -34,7 +36,7 @@ GIT_SUBTREE_XML := git-subtree.xml
 GIT_SUBTREE_TXT := git-subtree.txt
 GIT_SUBTREE_HTML := git-subtree.html
 
-all: $(GIT_SUBTREE)
+all:: $(GIT_SUBTREE)
 
 $(GIT_SUBTREE): $(GIT_SUBTREE_SH)
 	sed -e '1s|#!.*/sh|#!$(SHELL_PATH_SQ)|' $< >$@
