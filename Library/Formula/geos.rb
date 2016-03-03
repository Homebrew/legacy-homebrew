class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.5.0.tar.bz2"
  sha256 "49982b23bcfa64a53333dab136b82e25354edeb806e5a2e2f5b8aa98b1d0ae02"

  bottle do
    cellar :any
    sha256 "9b487c20bca29be6c37ad40cbde11b54f1bf56199006263ce32c1b01911e8fbc" => :el_capitan
    sha256 "6724b1a1996a44afb65734e28258ba9f7c28cf3ff2eaa9744a821545c3fc6b14" => :yosemite
    sha256 "c1d0bff59f1c12872dd32327658db11309697819440a027fccaf3350ded15146" => :mavericks
  end

  option :universal
  option :cxx11
  option "with-php", "Build the PHP extension"
  option "without-python", "Do not build the Python extension"
  option "with-ruby", "Build the ruby extension"

  depends_on "swig" => :build if build.with?("python") || build.with?("ruby")

  fails_with :llvm

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, %(PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup")
    end

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]

    args << "--enable-php" if build.with?("php")
    args << "--enable-python" if build.with?("python")
    args << "--enable-ruby" if build.with?("ruby")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
