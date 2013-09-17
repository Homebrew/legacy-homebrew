require 'formula'

class SagaCore < Formula
  homepage 'http://saga-project.org'
  url 'http://downloads.sourceforge.net/project/saga-gis/SAGA%20-%202.1/SAGA%202.1.0/saga_2.1.0.tar.gz'
  sha1 '1da4d7aed8ceb9efab9698b2c3bdb2670e65c5dd'

  head 'svn://svn.code.sf.net/p/saga-gis/code-0/trunk/saga-gis'

  depends_on :automake => :build
  depends_on :autoconf => :build
  depends_on :libtool => :build
  depends_on 'boost'
  depends_on 'gdal'
  depends_on 'jasper'
  depends_on 'proj'
  depends_on 'wget'
  depends_on 'wxmac'
  depends_on 'libharu' => :recommended

  def patches
    # Need to remove unsupported libraries from various Makefiles
    # http://sourceforge.net/apps/trac/saga-gis/wiki/Compiling%20SAGA%20on%20Mac%20OS%20X
    # The current SVN version doesn't have a saga_odbc folder, so that patch isn't applied
    if build.head?
      [
        "https://gist.github.com/nickrobison/6567217/raw/"
      ]
    else
      [
        "https://gist.github.com/nickrobison/6567217/raw/",
        "https://gist.github.com/nickrobison/6567238/raw/"
      ]
    end
  end

  def install

    # Missing proj4 headers needed for compile
    # http://sourceforge.net/p/saga-gis/bugs/145/
    system "wget", "https://gist.github.com/nickrobison/6531625/raw/projects.h", "-O", "src/modules_projection/pj_proj4/pj_proj4/projects.h"

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # Build App Bundle
    system "wget", "http://web.fastermac.net/~MacPgmr/SAGA/create_saga_app.sh"
    system "wget", "http://web.fastermac.net/~MacPgmr/SAGA/saga_gui.icns"
    chmod 0755, 'create_saga_app.sh'
    system "./create_saga_app.sh", "#{bin}/saga_gui", "SAGA"
    prefix.install "SAGA.app"
  end

  def caveats; <<-EOF.undent
    SAGA.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps

    Note that the SAGA GUI does not work very well yet.
    It has problems with creating a preferences file in the correct location and sometimes won't shut down (use Activity Monitor to force quit if necessary).
    EOF
  end
end
