class Apous < Formula
  version "0.2.1"
  desc "Apous is a simple tool that allows for easier authoring of Swift scripts."
  homepage "https://github.com/owensd/apous"
  url "https://github.com/owensd/apous/archive/v0.2.1.tar.gz"
  sha256 "d2a283bd328c7dae117de6078448e87a3f3b960876608dd238f5b87f698a10bc"

  depends_on :xcode => ["7.0", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.swift").write <<-EOS.undent
      println("Hello World")
    EOS

    require "open3"
    Open3.popen3("#{bin}/apous", "test.swift") do |_, stdout, _|
      assert_equal "Hello World", stdout.read.strip
    end
  end
end
