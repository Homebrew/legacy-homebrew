require "formula"

class Vala < Formula
  homepage "http://live.gnome.org/Vala"
  head "git://git.gnome.org/vala"
  url "http://ftp.acc.umu.se/pub/gnome/sources/vala/0.24/vala-0.24.0.tar.xz"
  sha1 "33a71a21e12e80cf1f4e0aa3b6a6523ff38e92c8"

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

    output = `#{testpath}/hello`
    assert_equal test_string, output
    assert_equal 0, $?.exitstatus
  end
end
