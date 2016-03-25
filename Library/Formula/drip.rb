class Drip < Formula
  desc "JVM launching without the hassle of persistent JVMs"
  homepage "https://github.com/flatland/drip"
  url "https://github.com/flatland/drip/archive/0.2.4.tar.gz"
  sha256 "9ed25e29759a077d02ddac61785f33d1f2e015b74f1fd934890aba4a35b3551d"

  bottle do
    cellar :any_skip_relocation
    sha256 "69a071055da45949c56df74c4959336f9511f863f447aed941a66547169f2c88" => :el_capitan
    sha256 "14711be9325c0b2df465197156b4b78bed673bf441011d0ce29d48a0c2ee0045" => :yosemite
    sha256 "69207c24aa1f8e6ba406e6cc3f811cd7000ee14c713cc32b49d72f2c76a702bc" => :mavericks
  end

  depends_on :java => "1.5+"

  def install
    system "make"
    libexec.install %w[bin src Makefile]
    bin.install_symlink libexec/"bin/drip"
  end
end
