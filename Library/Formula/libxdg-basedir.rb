class LibxdgBasedir < Formula
  desc "An implementation of the XDG Base Directory specifications"
  homepage "https://github.com/devnev/libxdg-basedir"
  url "http://github.com/devnev/libxdg-basedir/archive/libxdg-basedir-1.2.0.tar.gz"
  sha256 "1c2b0032a539033313b5be2e48ddd0ae94c84faf21d93956d53562eef4614868"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
