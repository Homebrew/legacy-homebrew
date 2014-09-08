require 'formula'

# Note, the version of pstree used on Linux requires
# the /proc file system, which is not available on OS X.

class Pstree < Formula
  homepage 'http://freshmeat.net/projects/pstree/'
  url 'ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.36.tar.gz'
  sha1 '1ca2e08c62d33afd37d78a215095258e77654b3f'

  def install
    system "make pstree"
    bin.install "pstree"
  end

  test do
    lines = `#{bin}/pstree #{Process.pid}`.strip.split("\n")
    assert lines[0].include?($0)
    assert lines[1].include?("#{bin}/pstree")
    assert_equal 0, $?.exitstatus
  end
end
