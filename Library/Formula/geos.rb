class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.5.0.tar.bz2"
  sha256 "49982b23bcfa64a53333dab136b82e25354edeb806e5a2e2f5b8aa98b1d0ae02"

  bottle do
    revision 1
    sha256 "8842b62a104c7b93c4123a0fcbc305a83441b74a9ef389ac291d2012dc333e38" => :el_capitan
    sha256 "3d8c95278881d07d9de4d18b20b81382180453a7f9b6b674e137cecbd0a3e2ee" => :yosemite
    sha256 "b94dd57f561757a9cc56fb238c95a2829e66f409ca4e6628dcc4432b6fe2dc38" => :mavericks
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
