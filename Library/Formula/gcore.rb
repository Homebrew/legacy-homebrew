class Gcore < Formula
  desc "Produce a snapshot (core dump) of a running process"
  homepage "http://osxbook.com/book/bonus/chapter8/core/"
  url "http://osxbook.com/book/bonus/chapter8/core/download/gcore-1.3.tar.gz"
  sha256 "6b58095c80189bb5848a4178f282102024bbd7b985f9543021a3bf1c1a36aa2a"

  bottle do
    cellar :any
    sha256 "88cd9f3114b081d8f079e1ca5625c49ca1bedc67cc827a07ce70fb8db78deb81" => :mavericks
    sha256 "48a90f4a6719d732ea99740c8423f810e615decfb10df124d47bc8322faebbc6" => :mountain_lion
    sha256 "f7a90a39ed7f20ff96b7b313e9e8cebf6e60f5919ec6fc981cce139e90a7f32c" => :lion
  end

  def install
    ENV.universal_binary
    system "make"
    bin.install "gcore"
  end
end
