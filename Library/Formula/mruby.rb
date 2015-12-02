class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "http://www.mruby.org"
  url "https://github.com/mruby/mruby/archive/1.2.0.tar.gz"
  sha256 "05ad0135a9c34158ff0cfd4631f4fbaed28cbb8243680d2c97ffdb9c246b1f3d"

  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a086424c6137f85d5c814e8a0216430081d9c583e2e3849231d82fd49ec118b8" => :el_capitan
    sha256 "9798334879beef5eba0f79bcd5720bc39b1466eade5254bcd8c38ef5a6a6b026" => :yosemite
    sha256 "874a62ef53850b0987d0be761b8b767072803bae69f620a6595bc8759822f0c6" => :mavericks
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
