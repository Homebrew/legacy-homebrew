class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "http://ndevilla.free.fr/iniparser/"
  head "https://github.com/ndevilla/iniparser.git"
  url "http://ndevilla.free.fr/iniparser/iniparser-3.1.tar.gz"
  sha256 "aedf23881b834519aea5e861b2400606d211da049cd59d3cfb4568e0d9eff5c5"

  conflicts_with "fastbit", :because => "Both install `include/dictionary.h`"

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install "libiniparser.a"
    include.install Dir["src/*.h"]
  end
end
