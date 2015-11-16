class BootClj < Formula
  desc "Build tooling for Clojure"
  homepage "http://boot-clj.com"
  url "https://github.com/boot-clj/boot-bin/releases/download/2.4.2/boot.sh",
      :using => :nounzip
  sha256 "8c045823c042e612d140528b4be136fcfa8bf1f1df390906bffcee6df46ca7a1"

  bottle :unneeded

  depends_on :java

  def install
    bin.install "boot.sh" => "boot"
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{testpath}"
    system "#{bin}/boot", "repl", "-e", "(System/exit 0)"
  end
end
