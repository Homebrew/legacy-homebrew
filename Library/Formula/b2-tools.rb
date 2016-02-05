class B2Tools < Formula
  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://www.backblaze.com/b2/docs/quick_command_line.html"
  url "https://docs.backblaze.com/public/b2_src_code_bundles/b2"
  version "0.3.12"
  sha256 "b50576006739c592333d13cbde9a21cbb3b7e2ba3b99bfedbd70a7adbe097aa8"

  def install
    bin.install "b2"
  end

  test do
    system "b2", "version"
  end
end
