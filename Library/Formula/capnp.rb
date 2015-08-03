class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.5.3.tar.gz"
  sha256 "cdb17c792493bdcd4a24bcd196eb09f70ee64c83a3eccb0bc6534ff560536afb"

  bottle do
    sha256 "df70e870b12a65442ced879e21418554e1594de20e86691f68c6a1ec17e60bf4" => :yosemite
    sha256 "26b92dca28761c408adfdfcc44d39baa7b0adfcccdc6d03a57377e14750ab3d0" => :mavericks
    sha256 "d6ffe25d6652a0dd63bd035889f08202ceb40e39413e2e64adea1af5cc2cb2bd" => :mountain_lion
  end

  needs :cxx11
  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/capnp", "--version"
  end
end
