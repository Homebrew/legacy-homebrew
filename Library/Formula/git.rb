require 'brewkit'

class GitManuals <UnidentifiedFormula
  @url='http://www.kernel.org/pub/software/scm/git/git-manpages-1.6.4.tar.bz2'
  @md5='851e1df833895c5046a994c28d3d8368'
end

class Git <Formula
  @url='http://kernel.org/pub/software/scm/git/git-1.6.4.tar.bz2'
  @md5='d41e3d43c8f1d23024fb3d3fe6aa3858'
  @homepage='http://git-scm.com'

  def install
    # the manuals come separately, well sort of, it's easier this way though
    man.mkpath
    GitManuals.new.brew { FileUtils.mv Dir['*'], man }

    # if these things are installed, tell git build system to not use them
    ENV['NO_FINK']='1'
    ENV['NO_DARWIN_PORTS']='1'

    system "./configure --prefix='#{prefix}' --disable-debug"
    system "make install"

    # these files are exact copies of the git binary, so like the contents
    # of libexec/git-core lets hard link them
    # I am assuming this is an overisght by the git devs
    %w[git-receive-pack git-upload-archive].each do |fn|
      (bin+fn).unlink
      (bin+fn).make_link bin+'git'
    end
  end
end