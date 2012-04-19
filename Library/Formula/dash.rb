require 'formula'

class Dash < Formula
  url 'http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.7.tar.gz'
  homepage 'http://gondor.apana.org.au/~herbert/dash/'
  sha1 'a3ebc16f2e2c7ae8adf64e5e62ae3dcb631717c6'

  head 'https://git.kernel.org/pub/scm/utils/dash/dash.git'

  depends_on "automake" if MacOS.xcode_version >= "4.3" and ARGV.build_head?

  def install
    if ARGV.build_head?
      system "aclocal"
      system "autoreconf -f -i -Wall,no-obsolete"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking",
                          "--enable-fnmatch",
                          "--enable-glob"
    system "make"
    system "make install"
  end

  def test
    system "#{HOMEBREW_PREFIX}/bin/dash -c \"echo Hello!\""
    puts "  ^--- That works."
  end
end
