class Pixz < Formula
  desc "Parallel, indexed, xz compressor"
  homepage "https://github.com/vasi/pixz"
  url "https://github.com/vasi/pixz/releases/download/v1.0.4/pixz-1.0.4.tar.gz"
  sha256 "38cabb2f065bd226c80db7984619fe1788c50da2b58558efeda3c16dcd768ce9"

  head "https://github.com/vasi/pixz.git"

  bottle do
    cellar :any
    sha256 "67f3a69e7d2443d5f1956af5fddf85d29ff4a515b01af3ffa24ace710364fbe1" => :el_capitan
    sha256 "130d33c9ee2fc8b5e02d36aab52314b4a1a323b4e5b79d9f55bb6853ceaf9e53" => :yosemite
    sha256 "4e8d29305549eb2e836bdef4d2075a2864f1333bf1bc763c0d886acee1e12cf1" => :mavericks
  end

  option "with-docs", "Build man pages using asciidoc and DocBook"

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "xz"

  if build.with? "docs"
    depends_on "asciidoc" => :build
    depends_on "docbook" => :build
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.with? "docs"
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "a2x", "--doctype", "manpage", "--format", "manpage", "src/pixz.1.asciidoc"
      man1.install "src/pixz.1"
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    testfile = testpath/"file.txt"
    testfile.write "foo"
    system "#{bin}/pixz", testfile, "#{testpath}/file.xz"
  end
end
