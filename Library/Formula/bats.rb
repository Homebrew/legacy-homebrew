class Bats < Formula
  desc "A TAP-compliant test framework for Bash scripts"
  homepage "https://github.com/sstephenson/bats"
  url "https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz"
  sha1 "cb8a5f4c844a5f052f915036130def31140fce94"
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
