class Codec2 < Formula
  desc "Open source speech codec."
  homepage "http://www.rowetel.com/blog/?page_id=452"
  url "https://files.freedv.org/codec2/codec2-0.5.tar.xz"
  sha256 "1ffda04ec6629f5ad5a38349c6d9d38d29bfbc1c677c12014ff20d480a343f17"

  depends_on "cmake" => :build

  def install
    mkdir "build_osx" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # 8 bytes of raw audio data (silence).
    (testpath/"test.raw").write([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack("C*"))
    system "#{bin}/c2enc", "2400", "test.raw", "test.c2"
  end
end
