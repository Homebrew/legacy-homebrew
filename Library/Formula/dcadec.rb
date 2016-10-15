class Dcadec < Formula
  homepage "https://github.com/foo86/dcadec"
  version "f5ffe27a25fb55efe68966677863b96223a11186"
  url "https://github.com/foo86/dcadec/archive/f5ffe27a25fb55efe68966677863b96223a11186.tar.gz"
  sha256 "970211a0c5bfaf319c6ae08f46faab98cdbc1e21442c4dd2624946fc1ea140eb"

  head "https://github.com/foo86/dcadec.git"

  def install
    system "make", "all"
    unless File.exist?("test/samples/README")
      system "git", "clone", "git@github.com:foo86/dcadec-samples.git", "test/samples"
    end
    system "make", "check"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/dcadec", "-h"
  end
end
