require 'formula'

class Automake < Formula
  homepage 'http://www.gnu.org/software/automake/'
  url 'http://ftpmirror.gnu.org/automake/automake-1.11.3.tar.gz'
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
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test automake`. Remove this comment before submitting
    # your pull request!
    system "#{HOMEBREW_PREFIX}/bin/automake --version"
  end
end
