require 'formula'

class Jgraph <Formula
  # use the Debian tarball, so their patches apply cleanly - this is old code
  url 'http://mirrors.kernel.org/debian/pool/main/j/jgraph/jgraph_83.orig.tar.gz'
  homepage 'http://www.cs.utk.edu/~plank/plank/jgraph/jgraph.html'
  md5 '73e273968945f69e0e2b7f3f9f0454b7'
  version '8.3'

  def patches
    'http://mirrors.kernel.org/debian/pool/main/j/jgraph/jgraph_83-22.diff.gz'
  end

  def install
    system 'make'

    man1.install 'jgraph.1'
    bin.install 'jgraph'
    (share+"jgraph").install 'complex-examples'
  end
end