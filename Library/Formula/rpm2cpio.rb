class Rpm2cpio < Formula
  desc "Tool to convert RPM package to CPIO archive"
  homepage "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/"
  url "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/files/rpm2cpio?revision=259745&view=co"
  version "1.3"
  sha256 "09651201a34771774fc4feaf5b409717e4bc052b82a89f3fc17c0cf578f8e608"

  bottle do
    cellar :any_skip_relocation
    sha256 "d26a07db8b6c1293171dc4937d81b2dc9936da0d52718d5f94ddd83524d5974e" => :el_capitan
    sha256 "623651ab4e150e1f05ba3a42aa6a18a1e7cb2c023cc3327cd3388f178e65d80a" => :yosemite
    sha256 "fcb6787ea96ae09d99bb6a7e28f653966277543b7a832661bb6da1a2903567cf" => :mavericks
  end

  depends_on "xz"

  def install
    bin.install "rpm2cpio" => "rpm2cpio.pl"
  end
end
