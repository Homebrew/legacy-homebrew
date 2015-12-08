class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "http://www.sleuthkit.org/"

  stable do
    url "https://downloads.sourceforge.net/project/sleuthkit/sleuthkit/4.2.0/sleuthkit-4.2.0.tar.gz"
    sha256 "91b287f19798ae480083c15401686e4a041c15f7a92054a5c0320bcb65604723"

    # Fix for https://github.com/sleuthkit/sleuthkit/issues/510
    patch do
      url "https://gist.github.com/anarchivist/c3c360db3b7d3f1b5f78/raw/4c403b57ec0d5819171eb33bffbab0bf3d6aab1b/tsk-4.2.0-exclude-jni-sample-verification.patch"
    end
  end

  bottle do
    cellar :any
    sha256 "25eed50da3aee6f63efa5adaf5d8915fe5ca33301fd415d47ed73ddbe6ab398a" => :yosemite
    sha256 "085a2b13ad2b6912cd2902be007c31feb299d617a9255f53e89a7994eb036a4e" => :mavericks
    sha256 "abe6fee63395ae2a7f81179d993d9f114bef6633f3845af52541fc79a58321ae" => :mountain_lion
  end

  head do
    url "https://github.com/sleuthkit/sleuthkit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "irods", :because => "both install `ils`"

  option "with-jni", "Build Sleuthkit with JNI bindings"

  depends_on :java
  depends_on :ant => :build
  depends_on "afflib" => :optional
  depends_on "libewf" => :optional

  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{buildpath}/.brew_home"
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.with? "jni"
      cd "bindings/java" do
        system "make"
      end
      prefix.install "bindings"
    end
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
