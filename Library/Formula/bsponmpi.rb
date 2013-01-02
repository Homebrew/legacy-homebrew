require 'formula'

class Bsponmpi < Formula
  url 'http://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz'
  homepage 'http://sourceforge.net/projects/bsponmpi'
  sha1 '07380f8c4e72a69dddf5deae786ecbb37811b489'

  depends_on 'scons' => :build
  depends_on MPIDependency.new(:cc, :cxx)

  def install
    system "scons -Q mode=release"
    lib.install Dir['lib/*']
    include.install Dir['include/*']
  end
end
