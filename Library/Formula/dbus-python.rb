require 'formula'

class DbusPython < Formula
  homepage 'http://dbus.freedesktop.org/doc/dbus-python/README.html'
  url 'http://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.0.tar.gz'
  sha1 '7a00f7861d26683ab7e3f4418860bd426deed9b5'
  version '1.2.0'

  depends_on 'pkg-config' => :build
  depends_on "dbus"
  depends_on "dbus-glib"

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test dbus-python`.
    system "false"
  end
end
