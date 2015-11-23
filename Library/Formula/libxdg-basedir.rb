class LibxdgBasedir < Formula
  desc "C implementation of the XDG Base Directory specifications"
  homepage "https://github.com/devnev/libxdg-basedir"
  url "https://github.com/devnev/libxdg-basedir/archive/libxdg-basedir-1.2.0.tar.gz"
  sha256 "1c2b0032a539033313b5be2e48ddd0ae94c84faf21d93956d53562eef4614868"

  bottle do
    cellar :any
    sha256 "7e165b0e949f559789981a5c0e0fd68bbf478943a0c9b03ad3778cecb0219691" => :yosemite
    sha256 "5c7bfadf4ca8b26c077eea7480df5a4ca3634b5823860a06ce2756050acbe84a" => :mavericks
    sha256 "63250688af20be1cb163530ea3849e4ca8b4ce93e15040904936414995af93f0" => :mountain_lion
  end

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
