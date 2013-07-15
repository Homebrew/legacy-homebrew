require 'formula'

class Ode < Formula
  homepage 'http://www.ode.org/'
  url 'http://sourceforge.net/projects/opende/files/ODE/0.12/ode-0.12.tar.bz2'
  sha1 '10e7aae6cc6b1afe523ed52e76afd5e06461ea93'

  head 'http://opende.svn.sourceforge.net/svnroot/opende/trunk'

  option 'enable-double-precision', 'Compile ODE with double precision'

  depends_on 'pkg-config' => :build

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    args = ["--prefix=#{prefix}",
            "--disable-demos"]
    args << "--enable-double-precision" if build.include? 'enable-double-precision'

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
