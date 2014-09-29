require "formula"

class Glbinding < Formula
  homepage "https://github.com/hpicgs/glbinding"
  url "https://github.com/hpicgs/glbinding/archive/v1.0.2.tar.gz"
  sha1 "19d6d143bd4106582af4c197e882222e86323820"

  depends_on "cmake" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

end
