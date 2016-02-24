class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://dl.bintray.com/byvoid/opencc/opencc-1.0.3.tar.gz"
  sha256 "5738c6996c6576539e8c5dea103456d86005b0656b476b9d97c65d468a9e7d97"

  bottle do
    sha256 "017b96bc4e668ce364e70f4b960b8a56d4593f27c9244e3b2e79a4ce53353cfa" => :yosemite
    sha256 "65527b74afd6a34dcdfd454c6bf365683bec1a63ffd6cea0d0a580790f85ae0e" => :mavericks
    sha256 "71c920c49cf7173a77cf1532cb445b83f7aef1a47817540b879432b631b768c1" => :mountain_lion
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_DOCUMENTATION:BOOL=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    input = "中国鼠标软件打印机"
    output = shell_output("echo #{input} | #{bin}/opencc")
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
