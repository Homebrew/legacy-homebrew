class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://bintray.com/artifact/download/aragozin/generic/sjk-plus-0.3.6.jar"
  sha256 "9420403139c1b843320fe07bac56f704b0d13715d53b5b2b5869d32103a99a47"

  depends_on :java

  def install
    lib.install "sjk-plus-0.3.6.jar"
    (bin/"sjk").write <<-EOS.undent
      #!/bin/sh

      PREFIX=`dirname $0`/../lib
      JARFILE=$PREFIX/sjk-plus-0.3.6.jar

      java -jar $JARFILE $@
    EOS
  end

  test do
    system "#{bin}/sjk", "jps"
  end
end
