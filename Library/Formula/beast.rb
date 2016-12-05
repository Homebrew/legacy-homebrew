require 'formula'

class Beast < Formula
  homepage 'http://beast.bio.ed.ac.uk/'
  url 'https://beast-mcmc.googlecode.com/files/BEASTv1.7.5.tgz'
  sha1 '825ddd87b67e4f13e078010810b028af78238c44'
  head 'http://beast-mcmc.googlecode.com/svn/trunk/'

  def install

    # build
    system "ant linux" if build.head?

    # install into package directory
    if build.head? then
      prefix.install Dir['release/Linux/BEASTv1.8.0pre/*']
    else
      prefix.install Dir['*']
    end

  end

  test do
    system "beast -help"
  end
end
