class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "http://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.4.tar.gz"
  sha256 "5910fe788677ca13532e3f47b7afaa01d72334d46a2d5e1d1f080f1173ff15ab"

  bottle do
    cellar :any
    sha256 "16fc79ac78ac33f1ef5835511ea7fd2d731cf01b29fee94b5e13960953602609" => :el_capitan
    sha256 "69c1659f65a9ca7644bf81ac4a8833ad23f63239c9f4cc14ab39bc203dbe2c68" => :yosemite
    sha256 "6b4ea8d82e310acb425325ad19d79ad039c3a3c88db0534e59d0fd973c16d058" => :mavericks
    sha256 "6288e9b2d40ea937f7964aa0ea86e99884d8f7729a8f57429ec51cdb53b3ca4f" => :mountain_lion
  end

  head do
    url "git://opencore-amr.git.sourceforge.net/gitroot/opencore-amr/fdk-aac"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-example"
    system "make", "install"
  end

  test do
    system "#{bin}/aac-enc", test_fixtures("test.wav"), "test.aac"
    assert File.exist?("test.aac")
  end
end
