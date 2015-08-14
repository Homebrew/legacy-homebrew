class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://dl.bintray.com/byvoid/opencc/opencc-1.0.3.tar.gz"
  sha256 "5738c6996c6576539e8c5dea103456d86005b0656b476b9d97c65d468a9e7d97"

  bottle do
    sha1 "f49556768692c346a700382cec6746ee3d425ff3" => :yosemite
    sha1 "e7024a546b9b322a5cdb43703004a93a5dcd21b9" => :mavericks
    sha1 "535532648a4f756a5c20ddda3da12953c7520128" => :mountain_lion
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
