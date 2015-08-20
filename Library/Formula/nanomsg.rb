class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/releases/download/0.6-beta/nanomsg-0.6-beta.tar.gz"
  sha256 "69e2098446c9cd2c067b5ba38567c9ba30bf861a515b3d0a9302cb21c1167a69"

  bottle do
    cellar :any
    sha256 "3d0724e03b1bda43509ddd2697241aebdf67e084814141fe02ff964a2b51496b" => :yosemite
    sha256 "c0f3ffe0375e039168efb280749671ee4c0cb228d5b1324d8f2a155f54f4a3fc" => :mavericks
    sha256 "9668ea4539430d48e20eb61e363506d884ebf2a5a1413004c9ec01ed6e5d3e65" => :mountain_lion
  end

  head do
    url "https://github.com/nanomsg/nanomsg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-test", "Skip verifying the build (Not Recommended)"
  option "without-doc", "Skip building manpages"
  option "without-nanocat", "Do not install nanocat tool"
  option "with-debug", "Compile with debug symbols"

  depends_on "pkg-config" => :build

  if build.with? "doc"
    depends_on "asciidoc" => :build
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.with? "doc"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--disable-nanocat" if build.without? "nanocat"
    args << "--enable-debug" if build.with? "debug"
    args << "--enable-doc" if build.with? "doc"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "-j1", "check" if build.bottle? || build.with?("test")
    system "make", "install"
  end

  test do
    bind = "tcp://127.0.0.1:8000"

    pid = fork do
      exec "#{bin}/nanocat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    begin
      output = shell_output("#{bin}/nanocat --req --connect #{bind} --format ascii --data brew")
      assert_match /home/, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
