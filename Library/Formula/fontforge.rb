require 'formula'

class Fontforge < Formula
  homepage 'http://fontforge.github.io/'

  stable do
    url 'https://github.com/fontforge/fontforge/archive/2.0.20140101.tar.gz'
    sha1 'abce297e53e8b6ff6f08871e53d1eb0be5ab82e7'
  end

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on 'pkg-config' => :build

  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'freetype'
  depends_on 'pango'
  depends_on 'cairo'
  depends_on 'readline'

  depends_on :python => :recommended
  depends_on 'giflib' => :recommended
  depends_on :libpng => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :recommended
  depends_on 'libxml2' => :recommended
  depends_on 'libspiro' => :recommended

  option 'with-x', 'Build with X11 support, including FontForge.app'
  depends_on :x11 if build.with? 'x'

  depends_on 'czmq' => :optional
  depends_on 'zeromq' => :optional

  def install
    args = ["--prefix=#{prefix}",
            '--disable-freetype-debugger',
            '--without-libuninameslist',
            '--without-libunicodenames']

    args << '--without-giflib' if build.without? 'giflib'
    args << '--without-libpng' if build.without? 'libpng'
    args << '--without-libjpeg' if build.without? 'jpeg'
    args << '--without-libtiff' if build.without? 'libtiff'
    args << '--without-libxml2' if build.without? 'libxml2'
    args << '--without-libspiro' if build.without? 'libspiro'

    args << '--with-x' if build.with? 'x'

    if build.with? 'python'
      args << '--enable-python-scripting'
      args << '--enable-python-extension'

      # This is required because pkg-config cannot find the python package.
      ENV['PYTHON_CFLAGS'] = `/usr/bin/python-config --cflags`.strip
      ENV['PYTHON_LIBS'] = `/usr/bin/python-config --libs`.strip
    else
      args << '--disable-python-scripting'
      args << '--disable-python-extension'
    end

    # Add environment variables for system libs
    ENV['ZLIB_CFLAGS'] = '-I/usr/include'
    ENV['ZLIB_LIBS'] = '-L/usr/lib -lz'

    system './autogen.sh'
    system "./configure", *args
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/fontforge", "-version"
  end
end
