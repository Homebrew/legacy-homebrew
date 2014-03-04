require 'formula'

class Bsponmpi < Formula
  homepage 'http://sourceforge.net/projects/bsponmpi'
  url 'https://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz'
  sha1 '07380f8c4e72a69dddf5deae786ecbb37811b489'

  depends_on 'scons' => :build
  depends_on :mpi => [:cc, :cxx]

  def install
    # Don't install 'CVS' folders from tarball
    rm_rf 'include/CVS'
    rm_rf 'include/tools/CVS'
    scons "-Q", "mode=release"
    prefix.install 'lib', 'include'
  end
end
