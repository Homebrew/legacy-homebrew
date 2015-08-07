class Pixz < Formula
  desc "Parallel, indexed, xz compressor"
  homepage "https://github.com/vasi/pixz"
  url "https://downloads.sourceforge.net/project/pixz/pixz-1.0.2.tgz"
  sha256 "af9dac41edd6bf57953471f7fcbd4793810003bf911593ba4c84f7cccb5f74af"

  head "https://github.com/vasi/pixz.git"

  option "with-docs", "Build man pages using asciidoc and DocBook"

  depends_on "libarchive"
  depends_on "xz"

  if build.with? "docs"
    depends_on "asciidoc" => :build
    depends_on "docbook" => :build
  end

  def install
    system "make"
    bin.install "pixz"

    if build.with? "docs"
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "a2x --doctype manpage --format manpage pixz.1.asciidoc"
      man1.install "pixz.1"
    end
  end

  test do
    system "#{bin}/pixz"
  end
end
