class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  homepage "http://yasm.tortall.net/"
  url "http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "db84535ba0b58448cdeab19d63e93f8dfecfc4b91cb06bd9919ca8d0f9b86ca4" => :el_capitan
    sha1 "86705ca09a33d0ba81000cadef9afe46a2072a70" => :yosemite
    sha1 "670a8b4722cfa032e7b0abcc618d54d0c32631bf" => :mavericks
    sha1 "772d7dbb840d3beb794980d1386f86db1cfd5bb4" => :mountain_lion
  end

  head do
    url "https://github.com/yasm/yasm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  resource "cython" do
    url "http://cython.org/release/Cython-0.20.2.tar.gz"
    sha256 "ed13b606a2aeb5bd6c235f8ed6c9988c99d01a033d0d21d56137c13d5c7be63f"
  end

  depends_on :python => :optional

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
    ]

    if build.with? "python"
      ENV.prepend_create_path "PYTHONPATH", buildpath+"lib/python2.7/site-packages"
      resource("cython").stage do
        system "python", "setup.py", "build", "install", "--prefix=#{buildpath}"
      end

      args << "--enable-python"
      args << "--enable-python-bindings"
    end

    # https://github.com/Homebrew/homebrew/pull/19593
    ENV.deparallelize

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.asm").write <<-EOS.undent
      global start
      section .text
      start:
          mov     rax, 0x2000004 ; write
          mov     rdi, 1 ; stdout
          mov     rsi, qword msg
          mov     rdx, msg.len
          syscall
          mov     rax, 0x2000001 ; exit
          mov     rdi, 0
          syscall
      section .data
      msg:    db      "Hello, world!", 10
      .len:   equ     $ - msg
    EOS
    system "#{bin}/yasm", "-f", "macho64", "test.asm"
    system "/usr/bin/ld", "-macosx_version_min", "10.7.0", "-lSystem", "-o", "test", "test.o"
    system "./test"
  end
end
