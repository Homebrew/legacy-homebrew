class OpenVcdiff < Formula
  desc "Encoder/decoder for the VCDIFF (RFC3284) format"
  homepage "https://code.google.com/p/open-vcdiff/"
  url "https://drive.google.com/uc?id=0B5WpIi2fQU1aNGJwVE9hUjU5clU&export=download"
  version "0.8.4"
  sha256 "2b142b1027fb0a62c41347600e01a53fa274dad15445a7da48083c830c3138b3"

  bottle do
    cellar :any
    sha256 "837a43737930f1f09cb5d21fe3bdc18b0cd0365fef954cfd30c81478348abc0f" => :yosemite
    sha256 "84ef8313b38bac7c846d70a9315fffc81daeb78d82ef5c0338cee438487cecbb" => :mavericks
    sha256 "aeac4cdebb0bc4796ca39b1ad04cc5a267bf9a34250d59b9268ed69999ee9f05" => :mountain_lion
  end

  def install
    system "./configure", "CPPFLAGS=-DGTEST_USE_OWN_TR1_TUPLE=1",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <google/vcdecoder.h>
      int main()
      {
        open_vcdiff::VCDiffDecoder decoder;
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lvcddec", "-lvcdcom",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
