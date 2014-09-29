require "formula"

class Vala < Formula
  homepage "http://live.gnome.org/Vala"
  head "git://git.gnome.org/vala"
  url "http://ftp.acc.umu.se/pub/gnome/sources/vala/0.26/vala-0.26.0.tar.xz"
  sha1 "ca8f84c7c271d6f47cad6526c176c5757655f63f"

  bottle do
    sha1 "2c6655e048f9823656254a41e5da4122bd5db304" => :mavericks
    sha1 "e839bc5c5dc90f0c4a4467a994bafc79e69680bd" => :mountain_lion
    sha1 "a5da67a71e4388ab171445c10ca9ab817b77d236" => :lion
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
