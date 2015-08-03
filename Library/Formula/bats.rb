class Bats < Formula
  desc "TAP-compliant test framework for Bash scripts"
  homepage "https://github.com/sstephenson/bats"
  url "https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz"
  sha256 "480d8d64f1681eee78d1002527f3f06e1ac01e173b761bc73d0cf33f4dc1d8d7"
  head "https://github.com/sstephenson/bats.git"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"testing.sh").write <<-EOS.undent
    #!/usr/bin/env bats
      @test "addition using bc" {
        result="$(echo 2+2 | bc)"
        [ "$result" -eq 4 ]
      }
    EOS

    chmod 0755, testpath/"testing.sh"
    output = shell_output("./testing.sh")
    assert output.include?("addition")
  end
end
