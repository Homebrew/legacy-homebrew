class Veraxx < Formula
  desc "Programmable tool for C++ source code"
  homepage "https://bitbucket.org/verateam/vera"
  url "https://bitbucket.org/verateam/vera/downloads/vera++-1.3.0.tar.gz"
  sha256 "9415657a09438353489db10ca860dd6459e446cfd9c649a1a2e02268da66f270"

  bottle do
    cellar :any
    sha256 "911f2a08616c7f62ca51d4ac7afa218c5e2f4d4c30099804340d2415f4886c68" => :yosemite
    sha256 "71288764fde2bf17878a2641ba5ddd3b173c0782938b51135c452ee3e16026b9" => :mavericks
    sha256 "7d3357f2d5bda931c9e5a7c3ccf9caa1cddb337d2e6cc22d3f791542d8e916ec" => :mountain_lion
  end

  depends_on "cmake" => :build

  # Use prebuilt docs to avoid need for pandoc
  resource "doc" do
    url "https://bitbucket.org/verateam/vera/downloads/vera++-1.3.0-doc.tar.gz"
    sha256 "122a15e33a54265d62a6894974ca2f0a8f6ff98742cf8e6152d310cc23099400"
  end

  def install
    # don't use system lua to avoid a dependency on lua 5.1
    system "cmake", ".", "-DVERA_USE_SYSTEM_LUA:BOOL=OFF", *std_cmake_args
    system "make", "install"
    system "ctest"

    resource("doc").stage do
      man1.install "vera++.1"
      doc.install "vera++.html"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/vera++ --version").strip
  end
end
