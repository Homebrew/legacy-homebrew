class Ode < Formula
  desc "Library for simulating articulated rigid body dynamics"
  homepage "http://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.13.1.tar.gz"
  sha256 "35e55e05c6c6ebb813a546017285a7aceedb3e8e55c8ff102e80e26bd84c5658"

  bottle do
    cellar :any
    revision 1
    sha256 "ffc8af301c91530661b4d83bba10af79b51a1204ee3111bcb1d73714a9073137" => :yosemite
    sha256 "3daad0d75cba00147966ed9f5ff27c825f25142c664d41341481943eb70f5ac4" => :mavericks
    sha256 "1956cbf2602b3a8ab1a1bc770a6bfa005eb9f484362b543176f9477ce3bd797e" => :mountain_lion
  end

  head do
    url "https://bitbucket.org/odedevs/ode/", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-double-precision", "Compile ODE with double precision"
  option "with-shared", "Compile ODE with shared library support"
  option "with-libccd", "Enable all libccd colliders (except box-cylinder)"

  deprecated_option "enable-double-precision" => "with-double-precision"
  deprecated_option "enable-shared" => "with-shared"
  deprecated_option "enable-libccd" => "with-libccd"

  depends_on "pkg-config" => :build

  def install
    args = ["--prefix=#{prefix}",
            "--disable-demos"]
    args << "--enable-double-precision" if build.with? "double-precision"
    args << "--enable-shared" if build.with? "shared"
    args << "--enable-libccd" if build.with? "libccd"

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      inreplace "bootstrap", "libtoolize", "$LIBTOOLIZE"
      system "./bootstrap"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
