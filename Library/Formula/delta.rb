class Delta < Formula
  desc "Programatically minimize files to isolate features of interest"
  homepage "http://delta.tigris.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/delta/delta_2006.08.03.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/delta/delta_2006.08.03.orig.tar.gz"
  sha256 "38184847a92b01b099bf927dbe66ef88fcfbe7d346a7304eeaad0977cb809ca0"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "202409012500969cfd034c9d44c441a809445a3b367d514357346438aa850f14" => :el_capitan
    sha256 "d3374cc3e84c93bb84615b1669503ea8b708ab65baf629ee0be9a728b12b10bc" => :yosemite
    sha256 "04102ae55ffc2cc4351816b010544b854c21f1c5e2a462a6af0e57ec2f57b501" => :mavericks
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
