class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "http://boot-clj.com"
  url "https://github.com/boot-clj/boot/releases/download/2.0.0/boot.sh",
      :using => :nounzip
  sha256 "2cb80c684a665f1979d5362f040144ab9891b2135b42ac2e1763b2f241b67f43"

  def install
    bin.install "boot.sh" => "boot"
  end

  test do
    system "#{bin}/boot", "repl", "-e", "(System/exit 0)"
  end
end
