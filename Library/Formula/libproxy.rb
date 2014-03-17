require "formula"

class Libproxy < Formula
  homepage "https://code.google.com/p/libproxy/"
  url "https://libproxy.googlecode.com/files/libproxy-0.4.11.tar.gz"
  sha1 "c037969434095bc65d29437e11a7c9e0293a5149"

  depends_on "cmake" => :build

  def patches
    # The following patches have been submitted upstream, see
    # https://code.google.com/p/libproxy/issues/detail?id=206.
    {
      :p0 => [
        "https://trac.macports.org/export/117895/trunk/dports/net/libproxy/files/patch-libproxy-cmake.diff",
        "https://trac.macports.org/export/117895/trunk/dports/net/libproxy/files/patch-libproxy-test-CMakeLists.txt.diff"
      ]
    }
  end

  def install
    args = std_cmake_args + %W[
      -DPYTHON_SITEPKG_DIR=#{lib}/python2.7/site-packages
      -DMP_MACOSX=NO
      -DWITH_DOTNET=NO
      -DWITH_GNOME2=NO
      -DWITH_GNOME3=NO
      -DWITH_KDE4=NO
      -DWITH_MOZJS=NO
      -DWITH_NM=NO
      -DWITH_PERL=NO
      -DWITH_PYTHON=YES
      -DWITH_VALA=NO
      -DWITH_WEBKIT3=NO
      -DWITH_WEBKIT=NO
    ]

    system "cmake", ".", *args
    system "make", "install"
  end
end
