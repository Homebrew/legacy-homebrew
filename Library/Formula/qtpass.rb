class Qtpass < Formula
  desc "GUI for pass, the standard unix password manager."
  homepage "https://qtpass.org/"
  url "https://github.com/IJHack/qtpass/archive/v1.0.3.tar.gz"
  sha256 "a61a29ddd5a874fcdcb915dbc9d91e10787be22d794cc8ebb2ba3cff27030c67"
  head "https://github.com/IJHack/qtpass.git"

  depends_on "qt" => :build
  depends_on :xcode => :build
  depends_on "pass" => :optional
  depends_on "gnupg"

  def install
    system "qmake", "PREFIX=#{prefix}"
    system "make", "install"
    prefix.install "QtPass.app"
  end

  test do
    system "true"
  end
end
