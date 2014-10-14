require 'formula'

class Ode < Formula
  homepage 'http://www.ode.org/'
  url 'https://downloads.sourceforge.net/project/opende/ODE/0.13/ode-0.13.tar.bz2'
  sha1 '0279d58cc390ff5cc048f2baf96cff23887f3838'

  head do
    url 'http://opende.svn.sourceforge.net/svnroot/opende/trunk'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option 'enable-double-precision', 'Compile ODE with double precision'
  option 'enable-libccd', 'enable all libccd colliders (except box-cylinder)'

  depends_on 'pkg-config' => :build

  def install
    args = ["--prefix=#{prefix}",
            "--disable-demos"]
    args << "--enable-double-precision" if build.include? 'enable-double-precision'
    args << "--enable-libccd" if build.include? "enable-libccd"

    if build.head?
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      inreplace 'autogen.sh', 'libtoolize', '$LIBTOOLIZE'
      system "./autogen.sh"
    end
    system "./configure", *args
    system "make"
    system "make install"
  end
end
