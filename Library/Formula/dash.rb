require 'formula'

class Dash < Formula
  homepage 'http://gondor.apana.org.au/~herbert/dash/'
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.8.tar.gz"
  sha1 "cd058935bba545427caa375337afe8a6309477d2"

  head do
    url 'https://git.kernel.org/pub/scm/utils/dash/dash.git'
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking",
                          "--enable-fnmatch",
                          "--enable-glob"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
