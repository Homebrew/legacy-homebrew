class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.30/vala-0.30.0.tar.xz"
  sha256 "61f0337b000f7ed6ef8c1fea87e0047d9bd7c0f91dd9c5b4eb70fd3fb883dedf"

  bottle do
    sha256 "edc3bc272827dd848deed5b85a1a6d372eb296b0c988ec792df09a2497b1b0b1" => :yosemite
    sha256 "afa1ae537d0c90408eb919465c05bc005735a5b62837f445d594c5acb3798cfb" => :mavericks
    sha256 "b55053adbebaf5d9d016002fb8d2a26b72398649e5a54c5621a68a9e62a31e62" => :mountain_lion
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
