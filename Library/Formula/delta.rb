class Delta < Formula
  desc "Programatically minimize files to isolate features of interest"
  homepage "http://delta.tigris.org/"
  url "https://mirrors.kernel.org/debian/pool/main/d/delta/delta_2006.08.03.orig.tar.gz"
  sha256 "38184847a92b01b099bf927dbe66ef88fcfbe7d346a7304eeaad0977cb809ca0"

  bottle do
    cellar :any
    revision 1
    sha256 "4c0625348a44ebe374ee26db8f5b24a5d9c9b4c70eee6cd8d45652d23f04fb75" => :yosemite
    sha256 "e931923ffc0b5ca84658eab38b9f9cc6103b174990e64f18eb7e0a3a197b1520" => :mavericks
    sha256 "90feeda114fe780cded88ba04ad3c16a5e09d5d94b07f1531c4a1768c3000f37" => :mountain_lion
  end

  def install
    system "make"
    bin.install "delta", "multidelta", "topformflat"
  end

  test do
    (testpath/"test1.c").write <<-EOS.undent
      #include <stdio.h>

      int main() {
        int i = -1;
        unsigned int j = i;
        printf("%d\n", j);
      }

    EOS
    (testpath/"test1.sh").write <<-EOS.undent
      #!/usr/bin/env bash

      clang -Weverything "$(dirname "${BASH_SOURCE[0]}")"/test1.c 2>&1 | \
      grep 'implicit conversion changes signedness'

    EOS

    chmod 0755, testpath/"test1.sh"
    system "#{bin}/delta", "-test=test1.sh", "test1.c"
  end
end
