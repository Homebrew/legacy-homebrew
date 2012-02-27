require 'formula'

class Automake < Formula
  homepage 'http://www.gnu.org/software/automake/'
  url 'http://ftpmirror.gnu.org/automake/automake-1.11.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/automake/automake-1.11.3.tar.gz'
  md5 '93ecb319f0365cb801990b00f658d026'

  depends_on "autoconf"

  if MacOS.xcode_version.to_f < 4.3 or File.file? "/usr/bin/automake"
    keg_only "Xcode (up to and including 4.2) provides (a rather old) Automake."
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    (share/"aclocal/dirlist").write <<-EOS.undent
      /usr/share/aclocal
      #{HOMEBREW_PREFIX}/share/aclocal
      EOS
  end

  def test
    system "#{bin}/automake --version"
  end
end
