class Libgxps < Formula
  desc "GObject based library for handling and rendering XPS documents"
  homepage "https://live.gnome.org/libgxps"
  url "https://download.gnome.org/sources/libgxps/0.2/libgxps-0.2.3.1.tar.xz"
  sha256 "370ec84251e2d3759ef6487d39f65157a22e49fbaf2c51e7a08bdbe198d6a536"

  bottle do
    cellar :any
    sha256 "fa03aed3a2f74fcf5e679f4a9b20a11a079bb99f6bb41f5de8cac4fabe3e1b90" => :yosemite
    sha256 "aaa4b251edb7849ffafc1a333e9491f5ad1c22d71765bf30197ab3d94ef42e81" => :mavericks
    sha256 "5771617e37c86898335f97531f67fbd19c76b4eea47bf71db4d9627ca519ffa8" => :mountain_lion
  end

  head do
    url "https://github.com/GNOME/libgxps.git"

    depends_on "libtool" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libarchive"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "gtk+" => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-man",
      "--prefix=#{prefix}"
    ]

    args << "--without-libjpeg" if build.without? "libjpeg"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-liblcms2" if build.without? "lcms2"

    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    mkdir_p [
      (testpath/"Documents/1/Pages/_rels/"),
      (testpath/"_rels/")
    ]

    (testpath/"FixedDocumentSequence.fdseq").write <<-EOS.undent
      <FixedDocumentSequence>
      <DocumentReference Source="/Documents/1/FixedDocument.fdoc"/>
      </FixedDocumentSequence>
      EOS
    (testpath/"Documents/1/FixedDocument.fdoc").write <<-EOS.undent
      <FixedDocument>
      <PageContent Source="/Documents/1/Pages/1.fpage"/>
      </FixedDocument>
      EOS
    (testpath/"Documents/1/Pages/1.fpage").write <<-EOS.undent
      <FixedPage Width="1" Height="1" xml:lang="und" />
      EOS
    (testpath/"_rels/.rels").write <<-EOS.undent
      <Relationships>
      <Relationship Target="/FixedDocumentSequence.fdseq" Type="http://schemas.microsoft.com/xps/2005/06/fixedrepresentation"/>
      </Relationships>
      EOS
    [
      "_rels/FixedDocumentSequence.fdseq.rels",
      "Documents/1/_rels/FixedDocument.fdoc.rels",
      "Documents/1/Pages/_rels/1.fpage.rels"
    ].each do |f|
      (testpath/f).write <<-EOS.undent
        <Relationships />
        EOS
    end

    Dir.chdir(testpath) do
      system "/usr/bin/zip", "-qr", (testpath/"test.xps"), "_rels", "Documents", "FixedDocumentSequence.fdseq"
    end
    system "#{bin}/xpstopdf", (testpath/"test.xps")
  end
end
