require 'formula'

class Dash < Formula
  homepage 'http://gondor.apana.org.au/~herbert/dash/'
  url 'http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.7.tar.gz'
  sha1 'a3ebc16f2e2c7ae8adf64e5e62ae3dcb631717c6'

  head do
    url 'https://git.kernel.org/pub/scm/utils/dash/dash.git'
    depends_on :autoconf
    depends_on :automake
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
