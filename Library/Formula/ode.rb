require 'formula'

class Ode < Formula
  desc "Library for simulating articulated rigid body dynamics"
  homepage 'http://www.ode.org/'
  url 'https://bitbucket.org/odedevs/ode/downloads/ode-0.13.1.tar.gz'
  sha1 '2fea08792e8f0fe606e929097fbec78ba926bcab'

  bottle do
    cellar :any
    sha1 "f4c142dc1276434e7482955e6932182065c9131c" => :yosemite
    sha1 "f69f17cd9bf1eed526959049c41cf3f28caed0da" => :mavericks
    sha1 "ca4743cc4e6cdce4ada98187f139c3e2acb4facb" => :mountain_lion
  end

  head do
    url 'http://bitbucket.org/odedevs/ode/', :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option 'enable-double-precision', 'Compile ODE with double precision'
  option 'enable-shared', 'Compile ODE with shared library support'
  option 'enable-libccd', 'enable all libccd colliders (except box-cylinder)'

  depends_on 'pkg-config' => :build

  def install
    args = ["--prefix=#{prefix}",
            "--disable-demos"]
    args << "--enable-double-precision" if build.include? 'enable-double-precision'
    args << "--enable-shared" if build.include? 'enable-shared'
    args << "--enable-libccd" if build.include? "enable-libccd"

    if build.head?
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      inreplace 'bootstrap', 'libtoolize', '$LIBTOOLIZE'
      system "./bootstrap"
    end
    system "./configure", *args
    system "make"
    system "make install"
  end
end
