require 'formula'

class Par2 < Formula
  homepage 'https://github.com/BlackIkeEagle/par2cmdline'
  url 'https://github.com/BlackIkeEagle/par2cmdline/archive/v0.6.12.tar.gz'
  sha1 'cee3b0642ffc9ddd73690f20c9e451563d2d9da4'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "par2tbb",
    :because => "par2 and par2tbb install the same binaries."

  def install
    system "aclocal"
    system "automake --add-missing"
    system "autoconf"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
