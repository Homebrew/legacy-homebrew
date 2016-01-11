class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.4.tar.gz"
  sha256 "5910fe788677ca13532e3f47b7afaa01d72334d46a2d5e1d1f080f1173ff15ab"

  bottle do
    cellar :any
    revision 1
    sha256 "998a5ef1cf61ece14c2bb47991c8941bd939af323c3a1de018ad31546c49b674" => :el_capitan
    sha256 "42e34f3a018e2902ee4082daa4df25d4a7453c015da8a4487f32fb8fadbb53af" => :yosemite
    sha256 "433da3720d89f9d8c2791137836635a86ff7bd5636afcf37f89f3f70d57e6777" => :mavericks
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
