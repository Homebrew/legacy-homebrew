require 'formula'

class Pyspatialite < Formula
  homepage 'http://code.google.com/p/pyspatialite/'
  url 'https://pypi.python.org/packages/source/p/pyspatialite/pyspatialite-3.0.1.tar.gz'
  sha1 'bcb3fdbc902a1b2f4451f2dad84dbbfba157ed4e'

  head 'https://code.google.com/p/pyspatialite/', :using => :hg

  depends_on :python
  depends_on 'geos'
  depends_on 'proj'
  depends_on 'sqlite'
  depends_on 'libspatialite'

  def patches
    # Patch to work with libspatialite 4.x, drop amalgamation support, dynamically
    # link libspatialite and sqlite3, and fix redeclaration build error
    # Reported upstream: http://code.google.com/p/pyspatialite/issues/detail?id=15
    # (not tested/supported with HEAD builds)
    "https://gist.github.com/dakcarto/7510460/raw" if build.stable?
  end

  def install
    # write setup.cfg
    (buildpath/"setup.cfg").write <<-EOS.undent
      [build_ext]
      include_dirs=#{HOMEBREW_PREFIX}/include/:#{HOMEBREW_PREFIX}/opt/sqlite/include/
      library_dirs=#{HOMEBREW_PREFIX}/lib:#{HOMEBREW_PREFIX}/opt/sqlite/lib
    EOS

    python do
      system python, "setup.py", "build"
      system python, "setup.py", "install", "--prefix=#{prefix}"
    end
  end

  def caveats
    python.standard_caveats if python
  end
end
