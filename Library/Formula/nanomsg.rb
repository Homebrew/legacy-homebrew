class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/releases/download/0.7-beta/nanomsg-0.7-beta.tar.gz"
  sha256 "43343e68947f819633b99fd91d2dd93ab44563b4079e9b780afd4488c4786297"

  bottle do
    cellar :any
    sha256 "c07fc3771bca0564ce5014199fb4c1d4c4c7dabd6e294c840cd8305602d91d87" => :el_capitan
    sha256 "171487d05d9e68fcfc7a30662fba99c178d93082858720f96a0afc0376864381" => :yosemite
    sha256 "6cc5919438afe609bf0da0cd1a450fd689711f958a977d5e0a227582a86cffa7" => :mavericks
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
