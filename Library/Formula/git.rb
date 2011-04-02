require 'formula'

class GitManuals < Formula
  url 'http://kernel.org/pub/software/scm/git/git-manpages-1.7.4.2.tar.bz2'
  md5 'bd3b79133abb9388318962637df145a7'
end

class GitHtmldocs < Formula
  url 'http://kernel.org/pub/software/scm/git/git-htmldocs-1.7.4.2.tar.bz2'
  md5 '15d9d5c5b2b1f261fdc15f2dd75bbb86'
end

class Git < Formula
  url 'http://kernel.org/pub/software/scm/git/git-1.7.4.2.tar.bz2'
  md5 '4b2df3f916061439ae105d7a27637925'
  homepage 'http://git-scm.com'

  def install
    # if these things are installed, tell git build system to not use them
    ENV['NO_FINK']='1'
    ENV['NO_DARWIN_PORTS']='1'
    # If local::lib is used you get a 'Only one of PREFIX or INSTALL_BASE can be given' error
    ENV['PERL_MM_OPT']='';
    # build verbosely so we can debug better
    ENV['V']='1'

    inreplace "Makefile" do |s|
      s.remove_make_var! %w{CFLAGS LDFLAGS}
    end

    system "make", "prefix=#{prefix}", "install"

    # Install the git bash completion file.
    # Put it into the Cellar so that it gets upgraded along with git upgrades.
    (prefix+'etc/bash_completion.d').install 'contrib/completion/git-completion.bash'

    # Install emacs support.
    (share+'doc/git-core/contrib').install 'contrib/emacs'

    # Install all other contrib files to share/contrib
    (share).install 'contrib'

    # these files are exact copies of the git binary, so like the contents
    # of libexec/git-core lets hard link them
    # I am assuming this is an overisght by the git devs
    git_md5 = (bin+'git').md5
    %w[git-receive-pack git-upload-archive].each do |fn|
      fn = bin + fn
      next unless git_md5 == fn.md5
      fn.unlink
      fn.make_link bin+'git'
    end

    # we could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier
    GitManuals.new.brew { man.install Dir['*'] }
    GitHtmldocs.new.brew { (share+'doc/git-doc').install Dir['*'] }
  end

  def caveats; <<-EOS.undent
    Bash completion and emacs support have been installed.

    The rest of the "contrib" folder has been copied to:
      #{share}/contrib
    EOS
  end
end
