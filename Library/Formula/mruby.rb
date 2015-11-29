class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "http://www.mruby.org"
  url "https://github.com/mruby/mruby/archive/1.2.0.tar.gz"
  sha256 "05ad0135a9c34158ff0cfd4631f4fbaed28cbb8243680d2c97ffdb9c246b1f3d"

  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any
    sha256 "8d9512bb6de7d04840076ae39c548b35147dbc4fab12e945bb9b69754126bc57" => :yosemite
    sha256 "6cec4dea7e5d40ffe44cbd4463ae4bbcd3fbca60aff502f87137838b00234670" => :mavericks
    sha256 "81d1bf52feb9c80440318cf954d4b5235182ad5c99324572e962dd3e3729953a" => :mountain_lion
  end

  depends_on "bison" => :build

  def install
    system "make"

    cd "build/host/" do
      lib.install Dir["lib/*.a"]
      prefix.install %w[bin mrbgems mrblib]
    end

    prefix.install "include"
  end

  test do
    system "#{bin}/mruby", "-e", "true"
  end
end
