require "language/go"

class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org/"
  url "https://github.com/asciinema/asciinema/archive/v1.1.1.tar.gz"
  sha256 "841b3393a65a4f49a01354aed4e2da6c30822dc83bcd988ff100fabda7038055"

  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any
    sha256 "58318ae8f0df8ec4ef5f08106e2c3e0c9157b030cb19e170e2e6fa9942c607a0" => :yosemite
    sha256 "983b9641df3c5ef0543b197368dbc272f57a230d3ea2541ababf4de7fb4c27fb" => :mavericks
    sha256 "69fcc08cfe0f382e26a5441a19bf1f6b9a19ccacb6c70b8044d1b8a5e96219fd" => :mountain_lion
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
