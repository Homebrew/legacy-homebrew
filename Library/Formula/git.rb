require 'brewkit'

class GitManuals <UnidentifiedFormula
  @url='http://kernel.org/pub/software/scm/git/git-manpages-1.6.3.1.tar.bz2'
  @md5='971d573e8f261feb83290a59728c2b33'
end

class Git <Formula
  @url='http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2'
  @md5='c1f4aab741359c29f0fbf28563ac7387'
  @homepage='http://git-scm.com'

  def install
    # the manuals come separately, well sort of, it's easier this way though
    GitManuals.new.brew { FileUtils.mv Dir['*'], man }

    system "./configure --prefix='#{prefix}' --disable-debug"
    system "make install"
  end
end