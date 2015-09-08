class Pixz < Formula
  desc "Parallel, indexed, xz compressor"
  homepage "https://github.com/vasi/pixz"
  url "https://github.com/vasi/pixz/releases/download/v1.0.3/pixz-1.0.3.tar.gz"
  sha256 "aba567c19513ddad3379260abc749b54e672aee8c89e1083a3e03860c97b3517"

  head "https://github.com/vasi/pixz.git"

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "xz"
  depends_on "asciidoc" => :build
  depends_on "docbook" => :build

  def install
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/lib/pkgconfig:#{HOMEBREW_PREFIX}/opt/libarchive/lib/pkgconfig"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    testfile = testpath/"file.txt"
    filecontent = "foo"
    testfile.write filecontent
    system "#{bin}/pixz", testfile, "#{testpath}/file.xz"
  end
end
