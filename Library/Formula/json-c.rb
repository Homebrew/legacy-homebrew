require "formula"

class JsonC < Formula
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.11-20130402.tar.gz"
  version "0.11"
  sha1 "1910e10ea57a743ec576688700df4a0cabbe64ba"

  bottle do
    cellar :any
    revision 1
    sha1 "937cec063a3ad30b7c806c59b2c605c21b47fbb4" => :mavericks
    sha1 "e1a3bdda78ce63c746582f58548da7a04a6baff1" => :mountain_lion
    sha1 "789f81ff4f5b7f5a1bbb971841496af8cd61c449" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make install"
  end
end
