class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "http://www.sleuthkit.org/"

  stable do
    url "https://downloads.sourceforge.net/project/sleuthkit/sleuthkit/4.1.3/sleuthkit-4.1.3.tar.gz"
    sha256 "67f9d2a31a8884d58698d6122fc1a1bfa9bf238582bde2b49228ec9b899f0327"

    # Upstream fix for https://github.com/sleuthkit/sleuthkit/issues/345
    patch do
      url "https://github.com/sleuthkit/sleuthkit/commit/39c62d6d169f8723c821ca7decdb8e124e126782.diff"
      sha256 "f9419d6665a89df5625487dd50c16c12d1680477797917f8ec9182db55df4f7f"
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
        system "ant"
      end
      prefix.install "bindings"
    end
  end
end
