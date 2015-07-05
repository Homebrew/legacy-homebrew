class Yaggo < Formula
  desc "Generate command-line parsers for C++"
  homepage "https://github.com/gmarcais/yaggo"
  url "https://github.com/gmarcais/yaggo/archive/v1.5.5.tar.gz"
  sha256 "8aae8024c3d832bf6a93513276a85413a129513d00c4f10c317124414d6a3f50"
  head "https://github.com/gmarcais/yaggo.git"

  def install
    bin.mkpath
    system "make", "DEST=#{bin}"
    doc.install "README.md"
  end

  test do
    system "#{bin}/yaggo", "--version"
  end
end
