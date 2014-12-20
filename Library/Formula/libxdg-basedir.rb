class LibxdgBasedir < Formula
  homepage "https://github.com/devnev/libxdg-basedir"
  url "http://github.com/devnev/libxdg-basedir/archive/libxdg-basedir-1.2.0.tar.gz"
  sha1 "e671b01b17c8cf785d95dd3aefa93e7cf31e56a5"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <basedir.h>
      int main() {
        xdgHandle handle;
        if (!xdgInitHandle(&handle)) return 1;
        xdgWipeHandle(&handle);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-lxdg-basedir", "-o", "test"
    system "./test"
  end
end
