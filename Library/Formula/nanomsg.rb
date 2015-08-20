class Nanomsg < Formula
  desc "Socket library in C"
  homepage "http://nanomsg.org"
  url "https://github.com/nanomsg/nanomsg/releases/download/0.6-beta/nanomsg-0.6-beta.tar.gz"
  sha256 "69e2098446c9cd2c067b5ba38567c9ba30bf861a515b3d0a9302cb21c1167a69"

  bottle do
    cellar :any
    sha1 "3a645be193f896f1a3b4f8593c1554656abdc4c1" => :yosemite
    sha1 "874eb890390defb22b89cbf4303d218d384bd9b6" => :mavericks
    sha1 "66775cd465f4351a92cb05824e279ed597b90270" => :mountain_lion
  end

  head do
    url "https://github.com/nanomsg/nanomsg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Verify the build with make check"
  option "with-doc", "Install man pages"
  option "without-nanocat", "Do not install nanocat tool"
  option "with-debug", "Compile with debug symbols"

  depends_on "pkg-config" => :build

  if build.with? "doc"
    depends_on "asciidoc" => :build
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.with? "doc"

    system "./autogen.sh" if build.head?

    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--disable-nanocat" if build.without? "nanocat"
    args << "--enable-debug" if build.with? "debug"
    args << "--enable-doc" if build.with? "doc"

    system "./configure", *args
    system "make"
    system "make", "-j1", "check" if build.with? "test"
    system "make", "install"
  end
end
