class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "http://www.call-cc.org/"
  url "http://code.call-cc.org/releases/4.10.0/chicken-4.10.0.tar.gz"
  sha256 "0e07f5abcd11961986950dbeaa5a40db415f8a1b65daff9c300e9b05b334899b"

  head "http://code.call-cc.org/git/chicken-core.git"

  bottle do
    sha256 "829af14ce63b487de7300073f256efbea7ecbd876ee577bff1dbc3080ec60c3b" => :yosemite
    sha256 "7b2c75d1cd7d3f74881885d6bf7522597beefe35a1ce99715ea1dff35d579e4b" => :mavericks
    sha256 "1f46226c58b1b7cd92f4d0c68cc0583e2c5ec4c2cce60b53193afca9a5d8be19" => :mountain_lion
  end

  def install
    ENV.deparallelize

    args = %W[
      PLATFORM=macosx
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      POSTINSTALL_PROGRAM=install_name_tool
    ]

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
  end
end
