class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.4.0.tar.gz"
  sha256 "659fae7ac229029e60a869a3b88c616cfd51cf2fba286cdfe3af3a052cb35b30"

  bottle do
    sha256 "9f9d87829624afc741c590614bb0dbf8858ebd5df6728e55925d3a8d82125d84" => :yosemite
    sha256 "2e6bed040b7f9fadce3c059327fbbbb60830b0ffb7eda41ccd452d9ebe04c865" => :mavericks
    sha256 "df76e18d45e3240416b47d2dc91a82a3ae0dc9291fd3e350953646b0148b9b41" => :mountain_lion
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

  test do
    system bin/"augtool", "print", etc
  end
end
