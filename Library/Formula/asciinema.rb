require "language/go"

class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org/"
  url "https://github.com/asciinema/asciinema/archive/v1.1.1.tar.gz"
  sha256 "841b3393a65a4f49a01354aed4e2da6c30822dc83bcd988ff100fabda7038055"

  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75f9832f791aa7557047e9e9a664c60597db4edd695b87fed226b06259cf9091" => :el_capitan
    sha256 "40c3f1466904bacee94c34775a53084ea559cf26dc25cfc66966809e56a45d3e" => :yosemite
    sha256 "6b9e943dd78548982c372fac5306462309d140bd8252cdb710e36a807fda3cde" => :mavericks
    sha256 "a9d488607f8c9abcfdc2c00fdde8c9833b2a6733e4a923565dd218723d7989a8" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/asciinema"
    ln_s buildpath, buildpath/"src/github.com/asciinema/asciinema"

    system "go", "build", "-o", bin/"asciinema"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/asciinema", "--version"
    system "#{bin}/asciinema", "--help"
  end
end
