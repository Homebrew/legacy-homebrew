class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.30/vala-0.30.0.tar.xz"
  sha256 "61f0337b000f7ed6ef8c1fea87e0047d9bd7c0f91dd9c5b4eb70fd3fb883dedf"

  bottle do
    sha256 "a912dde437bfe0acc89c7fcbd6a57882d4c2ca624ab8272d1facd74d72cb09e8" => :el_capitan
    sha256 "31431a28f845bac0b72bfe9fca125a7d72b1d58feb36036932717037b25f64ee" => :yosemite
    sha256 "5d7336e4fb80fcb70c446d427034b579f02cd172bd933da8bc546558447fac90" => :mavericks
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
    valac_args = [ # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      "#{path}",]
    system "#{bin}/valac", *valac_args
    assert File.exist?(testpath/"hello.c")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
