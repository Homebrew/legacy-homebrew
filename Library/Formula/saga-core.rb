require 'formula'

class SagaCore < Formula
  homepage 'http://saga-project.org'
  url 'http://downloads.sourceforge.net/project/saga-gis/SAGA%20-%202.1/SAGA%202.1.0/saga_2.1.0.tar.gz'
  sha1 '1da4d7aed8ceb9efab9698b2c3bdb2670e65c5dd'

  head 'svn://svn.code.sf.net/p/saga-gis/code-0/trunk/saga-gis'

  option "build-app", "Build SAGA.app Package"

  depends_on :automake
  depends_on :libtool
  depends_on 'boost'
  depends_on 'gdal'
  depends_on 'jasper'
  depends_on 'proj'
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

  appdata = {
    'create_saga_app.sh'  => '60467354402daa24ba707c21f9b04219e565b69c',
    'saga_gui.icns'       => '1ff67c6d600dd161684d3e8b33a1d138c65b00f4'
  }

 appdata.each do |name, sha|
   resource name do
     url "http://web.fastermac.net/~MacPgmr/SAGA/#{name}"
     sha1 sha
   end
 end

  resource 'projects' do
    url 'https://gist.github.com/nickrobison/6531625/raw/projects.h'
    sha1 '50e646dfd60c432c934d2020c75b6232dfac9202'

  end

  def install
    (buildpath/'src/modules_projection/pj_proj4/pj_proj4/').install resource('projects')

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    if build.include? "build-app"
          (buildpath).install resource('create_saga_app.sh')
          (buildpath).install resource('saga_gui.icns')
           chmod 0755, 'create_saga_app.sh'
           system "./create_saga_app.sh", "#{bin}/saga_gui", "SAGA"
           prefix.install "SAGA.app"
        end
  end

  if build.include? "build-app"
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

end
