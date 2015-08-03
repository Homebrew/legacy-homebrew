class Rpm2cpio < Formula
  desc "Tool to convert RPM package to CPIO archive"
  homepage "http://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/"
  url "http://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/files/rpm2cpio?revision=259745&view=co"
  version "1.3"
  sha256 "09651201a34771774fc4feaf5b409717e4bc052b82a89f3fc17c0cf578f8e608"

  depends_on "xz"

  def install
    bin.install "rpm2cpio" => "rpm2cpio.pl"
  end
end
