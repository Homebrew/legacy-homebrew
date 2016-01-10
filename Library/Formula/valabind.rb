class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "http://radare.org/"
  url "https://github.com/radare/valabind/archive/0.9.2.tar.gz"
  sha256 "84cc2be21acb671e737dab50945b3717f1c68917faf23af443d3911774f5e578"
  revision 2

  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "17cf6fefcd3b9ebd6cdf1d6934cf70a3c02f7988e95809705a7fbb9549c560bb" => :el_capitan
    sha256 "95fe16f73f5f17fdab2297259df01bd53ffd413a4c20a1366afbbdbbf3432234" => :yosemite
    sha256 "d0137a646c1b71861e8127c4eb3804f528db5e511fe88afdc491736a807e051e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
