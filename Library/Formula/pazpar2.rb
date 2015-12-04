class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.5.tar.gz"
  sha256 "a526ac9a91f6ac4683af3e27d58adb70755d82da7ad909eb98edf68dd07062d3"

  bottle do
    cellar :any
    sha256 "e9f9d2c673695192d7ae17edebaab7250424c770b46b4cfd1d21a51ee8e5d208" => :el_capitan
    sha256 "1908559c2937827579f5acd97e0c18d6bad701dac2bc50af0600d832c648ce0a" => :yosemite
    sha256 "4cfa57e70f207ac60f53596d6359b7c39e4c54abd49dc7069d8765b171d605e7" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
