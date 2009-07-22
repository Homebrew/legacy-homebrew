require 'brewkit'

class GitManuals <UnidentifiedFormula
  @url='http://www.kernel.org/pub/software/scm/git/git-manpages-1.6.3.3.tar.bz2'
  @md5='36be16310d1e24f23c966c8e17a499d7'
end

class Git <Formula
  @url='http://www.kernel.org/pub/software/scm/git/git-1.6.3.3.tar.bz2'
  @md5='91ae46ac01dadab1962beb064abd5b60'
  @homepage='http://git-scm.com'

  def install
    # the manuals come separately, well sort of, it's easier this way though
    man.mkpath
    GitManuals.new.brew { FileUtils.mv Dir['*'], man }

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