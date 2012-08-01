require 'formula'

class Ode < Formula
  homepage 'http://www.ode.org/'
  url 'http://sourceforge.net/projects/opende/files/ODE/0.12/ode-0.12.tar.bz2'
  sha1 '10e7aae6cc6b1afe523ed52e76afd5e06461ea93'

  head 'http://opende.svn.sourceforge.net/svnroot/opende/trunk'

  depends_on 'pkg-config' => :build

  if ARGV.build_head?
    # Requires newer automake and libtool
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def install
    if ARGV.build_head?
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      inreplace 'autogen.sh', 'libtoolize', '$LIBTOOLIZE'
      system "./autogen.sh"
    end
    system "./configure", "--prefix=#{prefix}", "--disable-demos"
    system "make"
    system "make install"
  end
end
