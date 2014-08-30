require "formula"

class Vala < Formula
  homepage "http://live.gnome.org/Vala"
  head "git://git.gnome.org/vala"
  url "http://ftp.acc.umu.se/pub/gnome/sources/vala/0.25/vala-0.25.2.tar.xz"
  sha1 "be2d3d2ae54c55583fe6a57a23bb6fe812d8bcdf"

  bottle do
    sha1 "34d6a34f7b98fd8f70b98d0ec22bf52180165c03" => :mavericks
    sha1 "f7b13157f9188a1c764a52d1e9a8cb9c1bdf3e6e" => :mountain_lion
    sha1 "8c0ae3a1d2491e44518e61bae6a14c5db63a5c45" => :lion
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
