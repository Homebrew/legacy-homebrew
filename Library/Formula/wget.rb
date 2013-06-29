require 'formula'

# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063

class Wget < Formula
  homepage 'http://www.gnu.org/software/wget/'
  url 'http://ftpmirror.gnu.org/wget/wget-1.14.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/wget/wget-1.14.tar.gz'
  sha1 'c487bce740b3a1847a35fb29b5c6700c46f639b8'

  head 'git://git.savannah.gnu.org/wget.git'

  option "enable-iri", "Enable iri support"
  option "enable-debug", "Build with debug support"

  depends_on "openssl" if MacOS.version == :leopard
  depends_on "libidn" if build.include? "enable-iri"

  if build.head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  def install
    system "./bootstrap" if build.head?
    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--with-ssl=openssl"]
    args << "--disable-debug" unless build.include? "enable-debug"
    args << "--disable-iri" unless build.include? "enable-iri"

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/wget", "-O", "-", "www.google.com"
  end
end
