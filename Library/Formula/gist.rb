class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.4.2.tar.gz"
  sha256 "4f570c6c32f04f529d0195c7cad93a48c9a53b2b3a9e69f68b732cdf31d3c362"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e017290b588b0c357ae29b6f1c14b3d47a81f8002c3ef8a29312e084d4b636f" => :el_capitan
    sha256 "164ad1f9427b51c135bb57699abc9b8ab42a1210097db88fb09387e81ceaa46a" => :yosemite
    sha256 "5342577ed510c43e1293e0b0571311dbde3cc17f6754a211adf3a471141a9119" => :mavericks
    sha256 "fff6af8f6c17c308009a4496032059defb8355ca646317dc8961475d2ffe683c" => :mountain_lion
  end

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/gist", "--version"
  end
end
