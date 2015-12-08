class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "http://www.sleuthkit.org/"

  stable do
    url "https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-4.2.0.tar.gz"
    sha256 "d71414134c9f8ce8e193150dd478c063173ee7f3b01f8a2a5b18c09aaa956ba7"
  end

  head do
    url "https://github.com/sleuthkit/sleuthkit.git"
  end

  bottle do
    cellar :any
    sha256 "25eed50da3aee6f63efa5adaf5d8915fe5ca33301fd415d47ed73ddbe6ab398a" => :yosemite
    sha256 "085a2b13ad2b6912cd2902be007c31feb299d617a9255f53e89a7994eb036a4e" => :mavericks
    sha256 "abe6fee63395ae2a7f81179d993d9f114bef6633f3845af52541fc79a58321ae" => :mountain_lion
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
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{buildpath}/.brew_home" if build.with? "jni"

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
