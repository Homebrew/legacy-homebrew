class Xcv < Formula
  desc "Cut, copy and paste files with Bash"
  homepage "https://github.com/busterc/xcv"
  url "https://github.com/busterc/xcv/archive/v1.0.1.tar.gz"
  sha256 "f2898f78bb05f4334073adb8cdb36de0f91869636a7770c8e955cee8758c0644"
  head "https://github.com/busterc/xcv"

  bottle :unneeded

  def install
    bin.install "xcv"
  end

  test do
    system "#{bin}/xcv"
  end
end
