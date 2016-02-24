class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "http://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-4.2.0.tar.gz"
  sha256 "d71414134c9f8ce8e193150dd478c063173ee7f3b01f8a2a5b18c09aaa956ba7"
  head "https://github.com/sleuthkit/sleuthkit.git"

  bottle do
    cellar :any
    sha256 "9be1ac084cd2ca38dfcf8d74357954051f8253d2e9fdf2118d4539bd41697f2b" => :el_capitan
    sha256 "a57e48483c05b733a9f67fba5759173b08fd89edd13ff5c83f504935ad556646" => :yosemite
    sha256 "c548ffdfbd4f20693ca708a09355b47dd0d049e1ce249cac3aefe96148270b0f" => :mavericks
  end

  conflicts_with "irods", :because => "both install `ils`"

  option "with-jni", "Build Sleuthkit with JNI bindings"
  option "with-debug", "Build debug version"

  if build.with? "jni"
    depends_on :java
    depends_on :ant => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "afflib" => :optional
  depends_on "libewf" => :optional

  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"
    ENV.java_cache if build.with? "jni"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          if build.without? "jni" then "--disable-java" end,
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.with? "jni"
      cd "bindings/java" do
        system "ant"
      end
      prefix.install "bindings"
    end
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
