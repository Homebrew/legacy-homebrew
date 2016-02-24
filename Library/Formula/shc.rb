class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.3a.tar.gz"
  version "3.9.3a"
  sha256 "76b3693cbf9db027e13c9f72d789d8197614ee872e421609a708ddb915bbc9d8"

  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cacc738baf6282ee5f8e65c306f47787fd9a817a2e75f38f91c93640ff6d48f6" => :el_capitan
    sha256 "bbd21d92cd05f24b27b0f5f122565e1ebdc6e61856ea18b293b5438bf3a24aed" => :yosemite
    sha256 "8e78fd63f9e46f1bcdbef8c94f1cebaffec264065e38cca1bfd7003d2d3fd057" => :mavericks
  end

  def install
    # Fix install scripts' permissions.
    # submitted upstream: https://github.com/neurobin/shc/pull/8
    chmod 0755, ["configure", "config/install-sh"]

    system "./configure"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.sh").write <<-EOS.undent
      #!/bin/sh
      exit 0
    EOS
    system "#{bin}/shc", "-f", "test.sh", "-o", "test"
    system "./test"
  end
end
