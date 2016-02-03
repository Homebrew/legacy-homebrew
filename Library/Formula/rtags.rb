class Rtags < Formula
  desc "ctags-like source code cross-referencer with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags.git",
      :tag => "v2.1",
      :revision => "ad85fda48b8c1038bc90c9fb0e8e79f2c5e30bca"

  head "https://github.com/Andersbakken/rtags.git"

  depends_on "cmake" => :build
  depends_on "llvm" => "with-clang"
  depends_on "openssl"

  def install
    # Homebrew llvm libc++.dylib doesn't correctly reexport libc++abi
    ENV.append("LDFLAGS", "-lc++abi")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    mkpath testpath/"src"
    (testpath/"src/foo.c").write <<-EOS.undent
        void zaphod() {
        }

        void beeblebrox() {
          zaphod();
        }
    EOS
    (testpath/"src/README").write <<-EOS.undent
        42
    EOS

    rdm = fork do
      $stdout.reopen("/dev/null")
      $stderr.reopen("/dev/null")
      exec "#{bin}/rdm", "-L", "log"
    end

    begin
      sleep 1
      pipe_output("#{bin}/rc -c", "clang -c src/foo.c", 0)
      sleep 1
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f src/foo.c:5:3")
      system "#{bin}/rc", "-q"
    ensure
      Process.kill 9, rdm
      Process.wait rdm
    end
  end
end
