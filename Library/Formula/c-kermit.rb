class CKermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "http://www.kermitproject.org/"
  url "http://www.kermitproject.org/ftp/kermit/archives/cku302.tar.gz"
  version "9.0.302"
  sha256 "0d5f2cd12bdab9401b4c836854ebbf241675051875557783c332a6a40dac0711"

  bottle do
    sha256 "01efa74febe89ad045ce0f6be8d80e10d9ef6a4efbc382b4573143d9d72ce48f" => :yosemite
    sha256 "e170c957947432e62c7131494dc694c39df7d09e5b2c6de0323d40e86e269188" => :mavericks
    sha256 "1ba733ef3ae9ffbdb1563741bf1c4852dd0f84c55c9e7f0da9e60942814fb61a" => :mountain_lion
  end

  def install
    system "make", "macosx"
    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    assert_equal "#{testpath}", shell_output("#{bin}/kermit -C PWD,exit").chomp
  end
end
