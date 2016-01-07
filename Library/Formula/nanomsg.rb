class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/releases/download/0.8-beta/nanomsg-0.8-beta.tar.gz"
  sha256 "75ce0c68a50cc68070d899035d5bb1e2bd75a5e01cbdd86ba8af62a84df3a947"

  bottle do
    cellar :any
    sha256 "a4ce042732d7112efac1f35c654f748615396b7f8defecfb55c3ac5c3ad2bcb6" => :el_capitan
    sha256 "68c2434b5da8880dd93f5bc6c6a58cf9a6a6315dcdc5d8a8d9586fe1cd35c6b4" => :yosemite
    sha256 "252a364dc0d5da396e3b3c194e502bace71b670cdbc3a073216255ee3d1fab12" => :mavericks
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
