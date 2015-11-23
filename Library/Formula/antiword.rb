class Antiword < Formula
  desc "Utility to read Word (.doc) files"
  homepage "http://www.winfield.demon.nl/"
  url "http://www.winfield.demon.nl/linux/antiword-0.37.tar.gz"
  sha256 "8e2c000fcbc6d641b0e6ff95e13c846da3ff31097801e86702124a206888f5ac"

  resource "sample.doc" do
    url "https://gist.github.com/bfontaine/f7e29599d329c41737ce/raw/ed4a3c5461924ed3bc18beb6b82681af9ad143d1/sample.doc"
    sha256 "b53b8d1843029b39b65ae7fdba265035c76610b85c2b9511bcade046d75d272f"
  end

  def install
    inreplace "antiword.h", "/usr/share/antiword", "#{share}/antiword"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags} -DNDEBUG",
                   "GLOBAL_INSTALL_DIR=#{bin}",
                   "GLOBAL_RESOURCES_DIR=#{share}/antiword"
    bin.install "antiword"
    (share/"antiword").install Dir["Resources/*"]
    man1.install "Docs/antiword.1"
  end

  def caveats; <<-EOS.undent
    You can install mapping files globally to:
      #{HOMEBREW_PREFIX}/share/antiword
    or locally to:
      ~/.antiword
    EOS
  end

  test do
    resource("sample.doc").stage do
      system "#{bin}/antiword", "sample.doc"
    end
  end
end
