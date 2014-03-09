require 'formula'

class Xplanet < Formula
  homepage 'http://xplanet.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.0/xplanet-1.3.0.tar.gz'
  sha1 '7c5208b501b441a0184cbb334a5658d0309d7dac'

  option "with-x", "Build for X11 instead of Aqua"
<<<<<<< HEAD
  option "with-all", "Installs the additional dependencies, except the JPL CSPICE package, included as part of Xplanet's default configuration.  CSPICE support will be built in Xplanet if it has already been installed."

  depends_on 'pkg-config' => :build
  depends_on "libpng"
=======
  option "complete", "Installs the additional dependencies included as part Xplanet's default configuration"

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
>>>>>>> 854985e4a14fd53c6643f78c3456709dd73294b2
  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'libtiff'
  depends_on :x11

<<<<<<< HEAD
  if build.include? "with-all"
    depends_on "netpbm"
    depends_on "freetype"
    depends_on "pango"
=======
  if build.include? 'complete'
    depends_on 'netpbm'
    depends_on 'freetype'
    depends_on 'pango'
>>>>>>> 854985e4a14fd53c6643f78c3456709dd73294b2
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    if build.with? "x"
      args << "--with-x"
    else
      args << "--with-aqua" << "--without-x"
    end

<<<<<<< HEAD
    if build.include? "with-all"
      netpbm = Formula["netpbm"].opt_prefix
      ENV.append 'CPPFLAGS', "-I#{netpbm}/include/netpbm"
      ENV.append 'LDFLAGS', "-L#{netpbm}/lib"
=======
    if build.include? "complete"
      pnm = Formula["netpbm"].opt_prefix
      ENV.append 'CPPFLAGS', "-I#{pnm}/include/netpbm"
      ENV.append 'LDFLAGS', "-L#{pnm}/lib"
>>>>>>> 854985e4a14fd53c6643f78c3456709dd73294b2
    end

    system "./configure", *args
    system "make install"
  end
end
