class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org"
  url "http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz"
  sha256 "5178c30b151d044aefb1b08bf54c3003a0ac55c59c866763997529d60770d5bc"

  bottle do
    cellar :any
    revision 1
    sha256 "337cf2bdc5b23f29b7a8ec22c2039e7c3ee98031f49bd4d0b255c53b00ccf4ff" => :el_capitan
    sha256 "bab1d6e940abc06c087651dbf49e050e27e0fe88a8069eaca49d3137616329f3" => :yosemite
    sha256 "e61e5048ee1f7c762274896cd469b68f2d0827543cb47de3536505c735224a2e" => :mavericks
    sha256 "4ad5ab851a5611d2cecdead0264357d93359f19e7b5af2a30807a8a33c68e721" => :mountain_lion
  end

  head do
    url "https://git.gnome.org/browse/libxml2", :using => :git

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :python => :optional

  keg_only :provided_by_osx

  option :universal

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?
    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--without-lzma"
    system "make"
    ENV.deparallelize
    system "make", "install"

    if build.with? "python"
      cd "python" do
        # We need to insert our include dir first
        inreplace "setup.py", "includes_dir = [", "includes_dir = ['#{include}', '#{MacOS.sdk_path}/usr/include',"
        system "python", "setup.py", "install", "--prefix=#{prefix}"
      end
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libxml/tree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    EOS
    args = `#{bin}/xml2-config --cflags --libs`.split
    args += %w[test.c -o test]
    system ENV.cc, *args
    system "./test"
  end
end
