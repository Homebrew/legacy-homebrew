class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.5.3.tar.gz"
  sha256 "cdb17c792493bdcd4a24bcd196eb09f70ee64c83a3eccb0bc6534ff560536afb"

  bottle do
    cellar :any
    sha256 "bd5a6b2c7961bad80928fdcf612619495e0c9208fe69ba5c207b797cd9fc8bb2" => :yosemite
    sha256 "f99f439becc2eb9bf12e60cb8af0245fffee9aecf9ed07dc460196fe3f2d5f6e" => :mavericks
    sha256 "9c11b6174a97e022be4ebe5e05435818234dedc11c194afe09bce81fbf8f9a50" => :mountain_lion
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
