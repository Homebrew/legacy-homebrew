class Atdtool < Formula
  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://github.com/lpenz/atdtool/archive/upstream/1.3.tar.gz"
  sha256 "eb634fd9e8a57d5d5e4d8d2ca0dd9692610aa952e28fdf24909fd678a8f39155"

  depends_on "txt2tags" => :build

  def install
    # Change the PREFIX to match the homebrew one, since there is no way to
    # pass it as an option for now edit the Makefile
    # https://github.com/lpenz/atdtool/pull/8
    inreplace "Makefile", "PREFIX=/usr/local", "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/atdtool", "#{prefix}/AUTHORS"
  end
end
