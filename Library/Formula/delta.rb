class Delta < Formula
  homepage "http://delta.tigris.org/"
  url "https://mirrors.kernel.org/debian/pool/main/d/delta/delta_2006.08.03.orig.tar.gz"
  sha256 "38184847a92b01b099bf927dbe66ef88fcfbe7d346a7304eeaad0977cb809ca0"

  bottle do
    cellar :any
    sha256 "1a2d27b054e1f63ec5770a12e0ed86236a16e9920f4c1765e44cf73967a64fa9" => :yosemite
    sha256 "5c0280a5fc93da0867237ca066e8fa14f8162af9aaf75a8dbd5a1cfc5df48f9c" => :mavericks
    sha256 "f3a5161d75202d42fe446ea7f1bdde25d5a55a6ca48e0ff1500c07f55b67e978" => :mountain_lion
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
