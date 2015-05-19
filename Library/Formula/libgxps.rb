class Libgxps < Formula
  desc "GObject based library for handling and rendering XPS documents"
  homepage "https://live.gnome.org/libgxps"
  url "http://ftp.gnome.org/pub/gnome/sources/libgxps/0.2/libgxps-0.2.2.tar.xz"
  sha256 "39d104739bf0db43905c315de1d8002460f1a098576f4418f69294013a5820be"

  bottle do
    cellar :any
    sha1 "924309fd03db773717136c28f18c252287fb594e" => :yosemite
    sha1 "824b1ccbe6227f3daf53ba511186f45b7e57a8d2" => :mavericks
    sha1 "1782c7a78c41172a401cef801e0995818ec23e33" => :mountain_lion
  end

  head do
    url "https://github.com/GNOME/libgxps.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end
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
      "--prefix=#{prefix}",
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
      (testpath/"_rels/"),
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
      "Documents/1/Pages/_rels/1.fpage.rels",
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
