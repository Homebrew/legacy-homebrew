require 'formula'

class GitManuals < Formula
  url 'http://kernel.org/pub/software/scm/git/git-manpages-1.7.1.1.tar.bz2'
  md5 'd56a2b79e76efa7b207335f562fbefbe'
end

class GitHtmldocs < Formula
  url 'http://kernel.org/pub/software/scm/git/git-htmldocs-1.7.1.1.tar.bz2'
  md5 '642edbab5bcf66694c07e0929c0ca223'
end

class Git < Formula
  url 'http://kernel.org/pub/software/scm/git/git-1.7.1.1.tar.bz2'
  md5 '1b116a3e2ecce46a89e4272abf0de955'
  homepage 'http://git-scm.com'

  def install
    # if these things are installed, tell git build system to not use them
    ENV['NO_FINK']='1'
    ENV['NO_DARWIN_PORTS']='1'
    # If local::lib is used you get a 'Only one of PREFIX or INSTALL_BASE can be given' error
    ENV['PERL_MM_OPT']='';
    # build verbosely so we can debug better
    ENV['V'] = '1'

    inreplace "Makefile" do |s|
      s.remove_make_var! %w{CFLAGS LDFLAGS}
    end

    system "make", "prefix=#{prefix}", "install"

    # Install the git bash completion file
    (etc+'bash_completion.d').install 'contrib/completion/git-completion.bash'

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
    doc = share+'doc/git-doc'
    GitHtmldocs.new.brew { doc.install Dir['*'] }
  end
end
