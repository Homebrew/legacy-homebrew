class Wv2 < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "http://wvware.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/wvware/wv2-0.4.2.tar.bz2"
  sha256 "9f2b6d3910cb0e29c9ff432f935a594ceec0101bca46ba2fc251aff251ee38dc"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "libgsf"

  def install
    ENV.append "LDFLAGS", "-liconv -lgobject-2.0" # work around broken detection
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
