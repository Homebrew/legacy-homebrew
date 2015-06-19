class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "http://radare.org/"
  head "https://github.com/radare/valabind.git"
  url "https://github.com/radare/valabind/archive/0.9.2.tar.gz"
  sha256 "84cc2be21acb671e737dab50945b3717f1c68917faf23af443d3911774f5e578"

  bottle do
    cellar :any
    sha256 "8aab7c9f2004e9e2378ed9320b3e3aca5b226a921fe097aa878077e58c1aac6c" => :yosemite
    sha256 "45a23247c6eaf72c3a5e5fcfb5542d29eded403c3a1e72e80979a72625a454f8" => :mavericks
    sha256 "74553dd4ddef8e5e2ceeda4a77d2c154de6388e224b23d94d04e37dbc6bf17f6" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
