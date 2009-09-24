require 'brewkit'

class GitManuals <Formula
  url 'http://kernel.org/pub/software/scm/git/git-manpages-1.6.4.4.tar.bz2'
  md5 '5ee880f408f1299d541c273fb7e3c1db'
end

class Git <Formula
  url 'http://kernel.org/pub/software/scm/git/git-1.6.4.4.tar.bz2'
  md5 'b150352782998ca1f84185e6af53ec26'
  homepage 'http://git-scm.com'

  def install
    # if these things are installed, tell git build system to not use them
    ENV['NO_FINK']='1'
    ENV['NO_DARWIN_PORTS']='1'

    system "./configure --prefix=#{prefix}"
    system "make install"

    # these files are exact copies of the git binary, so like the contents
    # of libexec/git-core lets hard link them
    # I am assuming this is an overisght by the git devs
    %w[git-receive-pack git-upload-archive].each do |fn|
      next unless (bin+'git').stat.size == (bin+fn).stat.size
      (bin+fn).unlink
      (bin+fn).make_link bin+'git'
    end

    # we could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier
    GitManuals.new.brew { man.install Dir['*'] }
  end
end
