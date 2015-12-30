class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.2.tar.gz"
  sha256 "b3aabc5d307a80049139bce1b36cb2fd2a9c6c80a6cd951b69dc23e3af91a593"

  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4c83fbb72f572817e485f2c77e385d021fa89bff28bda69ef1650c289e4114d" => :el_capitan
    sha256 "5d7427f85c6c9dadeea9aac1574ec9cc81376f05020f83013d1f824ba3e5a8ca" => :yosemite
    sha256 "a0108e4234ce15d00a0e0864e5a5d36ffedf5d7cb4c68baec3251c4c3e49ebfe" => :mavericks
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
