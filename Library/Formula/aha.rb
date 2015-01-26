class Aha < Formula
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.8.tar.gz"
  sha1 "45d91e1cda8663e8bf0c5fa8b94e4d2290aa9895"

  bottle do
    cellar :any
    sha1 "58fb4e7cd5a7c4bf18aded8d8d8ab16ce65fae1e" => :yosemite
    sha1 "a2dd6ea63dbe26867c6cbe51d998fe1a09c7692e" => :mavericks
    sha1 "9f3de31efaa60c4302c10a30a2e4bcd7a50f7af8" => :mountain_lion
  end

  def install
    system "make"
    bin.install "aha"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match /color:purple;">rain.*color:blue;">pill/, out
  end
end
