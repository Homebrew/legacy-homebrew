require "formula"

class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.28/vala-0.28.0.tar.xz"
  sha256 "0d9e3bd3f82145664875f7c29b2f544ba92d2814f75412948f774c0727fc977f"

  bottle do
    sha1 "9e829527c2662e38375a04116802f8975109fc5b" => :yosemite
    sha1 "22d08887de342be1704472063003caa6c3a33f03" => :mavericks
    sha1 "0ad74c02e196ac61098dddc8b8c4caec7d91a044" => :mountain_lion
  end

  devel do
    url "http://ftp.gnome.org/pub/GNOME/sources/vala/0.27/vala-0.27.1.tar.xz"
    sha256 "0bce939c011c34478da840f869b3c24d02e8f1c92691c587c1fe289a5533cd77"
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
