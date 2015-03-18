class FdkAac < Formula
  homepage "http://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.4.tar.gz"
  sha256 "5910fe788677ca13532e3f47b7afaa01d72334d46a2d5e1d1f080f1173ff15ab"

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
