class Codec2 < Formula
  desc "Open source speech codec."
  homepage "http://www.rowetel.com/blog/?page_id=452"
  url "https://files.freedv.org/codec2/codec2-0.5.tar.xz"
  sha256 "1ffda04ec6629f5ad5a38349c6d9d38d29bfbc1c677c12014ff20d480a343f17"

  bottle do
    cellar :any
    sha256 "0a385047266db01ce5ee29c112454efd18c5036f8bdca96ec018a5fb1c10064a" => :el_capitan
    sha256 "9cfba02811b48abea043b61e8594e6bc810b6b378aceeb3ba6f51b9a0bb6e966" => :yosemite
    sha256 "3763c18aa7cb38b36a9b8770acae0b222f114b7cabd7035736fefa833536f614" => :mavericks
  end

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
