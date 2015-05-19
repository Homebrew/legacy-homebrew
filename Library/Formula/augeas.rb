class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.3.0.tar.gz"
  sha1 "052694bc84e3b8246dd32808b0e0e8c41c3de40b"

  bottle do
    sha1 "374c491053aff309ba2ae417f3bb6e888a4fbae9" => :yosemite
    sha1 "21e1bb5ec9d1bf623e61cf6ab1179a1d09cd9060" => :mavericks
    sha1 "3b3c437736fb3e4edb5c60a73f0097e91703dd1f" => :mountain_lion
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "readline"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    # libfa example program doesn't compile cleanly on OSX, so skip it
    inreplace "Makefile" do |s|
      s.change_make_var! "SUBDIRS", "gnulib/lib src gnulib/tests tests man doc"
    end

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Lenses have been installed to:
      #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end
end
