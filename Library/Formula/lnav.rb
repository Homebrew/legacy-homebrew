require 'formula'

class Lnav < Formula
  homepage 'http://lnav.org'
  url 'https://github.com/tstack/lnav/releases/download/v0.7.2/lnav-0.7.2.tar.gz'
  sha1 'f679a5a3b52a05edf6ab2446182e085d1953c1fc'

  bottle do
    sha256 "8c178133d92e3fe244d60aef590f17943ae494a12a5b0be40bad789dc6646de2" => :yosemite
    sha256 "ab85080c57d96be9a391ce8e1eff67fda43653c1f0328290d4ba2b8253ca3af0" => :mavericks
    sha256 "26892fd713417b2b84a6615a63d9492a683f53a7fb497dd2b4a681d7267cc2a5" => :mountain_lion
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on 'readline'
  depends_on 'pcre'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end
end
