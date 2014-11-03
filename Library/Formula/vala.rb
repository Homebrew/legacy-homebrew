require "formula"

class Vala < Formula
  homepage "http://live.gnome.org/Vala"
  head "git://git.gnome.org/vala"
  url "http://ftp.acc.umu.se/pub/gnome/sources/vala/0.26/vala-0.26.0.tar.xz"
  sha1 "ca8f84c7c271d6f47cad6526c176c5757655f63f"

  bottle do
    revision 1
    sha1 "ef2b97e0a0e213024dddc03070397df0feb238e0" => :yosemite
    sha1 "b513f77a68e16829be5e36e2721262734e4004ac" => :mavericks
    sha1 "f3ad6dda21d9d219f79c2aa435375947a034e405" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<-EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [# Build with debugging symbols.
                  "-g",
                  # Use Homebrew's default C compiler.
                  "--cc=#{ENV.cc}",
                  # Save generated C source code.
                  "--save-temps",
                  # Vala source code path.
                  "#{path}"]
    system "#{bin}/valac", *valac_args
    assert File.exist?(testpath/"hello.c")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
