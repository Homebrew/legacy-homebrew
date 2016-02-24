class Ode < Formula
  desc "Library for simulating articulated rigid body dynamics"
  homepage "http://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.14.tar.gz"
  sha256 "1072fc98d9d00262a0d6136e7b9ff7f5d953bbdb23b646f426909d28c0b4f6db"
  head "https://bitbucket.org/odedevs/ode/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "a819c7f5b726beab6c2dbb4bd4e0e09535e31e012fd6c2827d798eba88ecefec" => :el_capitan
    sha256 "978f6488c0bec75919bfc2b12882a5d7c517e5e9a3ff3c55eea5bc9a3f99b7fb" => :yosemite
    sha256 "1909c03ba89ab957497e58a02a95972e57f37bb7d4a45a5e7aa822eb37177e5c" => :mavericks
  end

  option "with-double-precision", "Compile ODE with double precision"
  option "with-shared", "Compile ODE with shared library support"
  option "with-libccd", "Enable all libccd colliders (except box-cylinder)"
  option "with-x11", "Build the drawstuff library and demos"

  deprecated_option "enable-double-precision" => "with-double-precision"
  deprecated_option "enable-shared" => "with-shared"
  deprecated_option "enable-libccd" => "with-libccd"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-double-precision" if build.with? "double-precision"
    args << "--enable-shared" if build.with? "shared"
    args << "--enable-libccd" if build.with? "libccd"
    args << "--with-demos" if build.with? "x11"

    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "./bootstrap"

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
