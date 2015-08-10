class Ode < Formula
  desc "Library for simulating articulated rigid body dynamics"
  homepage "http://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.13.1.tar.gz"
  sha256 "35e55e05c6c6ebb813a546017285a7aceedb3e8e55c8ff102e80e26bd84c5658"

  bottle do
    cellar :any
    sha1 "f4c142dc1276434e7482955e6932182065c9131c" => :yosemite
    sha1 "f69f17cd9bf1eed526959049c41cf3f28caed0da" => :mavericks
    sha1 "ca4743cc4e6cdce4ada98187f139c3e2acb4facb" => :mountain_lion
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
