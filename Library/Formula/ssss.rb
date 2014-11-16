require "formula"

class Ssss < Formula
  homepage "http://point-at-infinity.org/ssss/"
  url "http://point-at-infinity.org/ssss/ssss-0.5.tar.gz"
  sha1 "3f8f5046c2c5c3a2cf1a93f0a9446681852b190e"

  depends_on "gmp"
  depends_on "xmltoman"

  def install
    inreplace "Makefile" do |s|
      # Compile with -DNOMLOCK to avoid warning on every run on OS X.
      s.gsub! /\-W /, "-W -DNOMLOCK $(CFLAGS) $(LDFLAGS)"
    end

    system "make"
    man1.install "ssss.1"
    bin.install %w{ ssss-combine ssss-split }
  end
end
