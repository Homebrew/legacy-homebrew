require "formula"

class Vala < Formula
  homepage "http://live.gnome.org/Vala"
  url "http://ftp.gnome.org/pub/GNOME/sources/vala/0.26/vala-0.26.1.tar.xz"
  sha256 "8407abb19ab3a58bbfc0d288abb47666ef81f76d0540258c03965e7545f59e6b"

  bottle do
    sha1 "9e829527c2662e38375a04116802f8975109fc5b" => :yosemite
    sha1 "22d08887de342be1704472063003caa6c3a33f03" => :mavericks
    sha1 "0ad74c02e196ac61098dddc8b8c4caec7d91a044" => :mountain_lion
  end

  depends_on "pkg-config" => :run
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
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
