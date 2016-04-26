class Asciinema2gif < Formula
  desc "Generate animated GIFs from asciinema terminal recordings"
  homepage "https://github.com/tav/asciinema2gif"
  url "https://github.com/tav/asciinema2gif/archive/0.2.tar.gz"
  sha256 "fa5834aaec162b992768bed854d69eecff0862c733d4be0334dbc3b9fe86481c"
  head "https://github.com/tav/asciinema2gif.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "099cfce8b0f1523419e202d6a3c2ae2be5834eb973e1bcafa203acf2f47a8d3c" => :el_capitan
    sha256 "3ae4862511bf5754fefe5a70ae39c5c2658902a2ea0706a685cfe2a308848faa" => :yosemite
    sha256 "5d827a76fda0a7cd372cc4a64d39514a9ae881fc845307dc9be9d41b12a6a89d" => :mavericks
  end

  depends_on "gifsicle"
  depends_on "imagemagick"
  depends_on "phantomjs"

  def install
    (libexec/"bin").install %w[asciinema2gif render.js]
    bin.write_exec_script libexec/"bin/asciinema2gif"
  end

  test do
    system "#{bin}/asciinema2gif", "--help"
  end
end
