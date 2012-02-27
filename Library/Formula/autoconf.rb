require 'formula'

class Autoconf < Formula
  url 'http://ftpmirror.gnu.org/autoconf/autoconf-2.68.tar.gz'
  homepage 'http://www.gnu.org/software/autoconf'
  md5 'c3b5247592ce694f7097873aa07d66fe'

  if MacOS.xcode_version.to_f < 4.3 or File.file? "/usr/bin/autoconf"
    keg_only "Xcode (up to and including 4.2) provides (a rather old) Autoconf."
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{HOMEBREW_PREFIX}/bin/autoconf --version"
  end
end
