
class Kobalt < Formula
  desc "A build system"
  homepage "http://beust.com/kobalt"
  url "https://github.com/cbeust/kobalt/releases/download/0.633/kobalt-0.633.zip"
  version "0.633"
  sha256 "bb468a7b8761de20c4700e18a6de55ee0712edd0e9d04748e53592c91389c94e"

  def install
    prefix.install "kobaltw"
    prefix.install "kobalt"

    # kobaltw expects the jar file to be in ./kobalt/wrapper so
    # install it to /usr/local/bin manually and correct the
    # jar location
    kobaltw = "/usr/local/bin/kobaltw"

    rm "#{kobaltw}"
    ln_s "#{prefix}/kobaltw", kobaltw
    chmod 0755, prefix/"kobaltw"
    inreplace "#{prefix}/kobaltw", "$(dirname $0)", prefix
  end

  test do
    (testpath/"src/main/kotlin/com/A.kt").write <<-EOS.undent
      package com
      class A
      EOS

    (testpath/"kobalt/src/Build.kt").write <<-EOS.undent
      import com.beust.kobalt.*
      import com.beust.kobalt.api.*
      import com.beust.kobalt.plugin.packaging.*

      val p = project {
        name = "test"
        version = "1.0"
        assemble {
        jar {}
      }
    }
    EOS

    system "kobaltw assemble"
    output = "kobaltBuild/libs/test-1.0.jar"
    assert File.exists?(output), "Couldn't find #{output}"
  end
end
