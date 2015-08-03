class Ee < Formula
  desc "Terminal (curses-based) text editor with pop-up menus"
  homepage "http://www.users.qwest.net/~hmahon/"
  url "http://www.users.qwest.net/~hmahon/sources/ee-1.4.6.src.tgz"
  sha256 "a85362dbc24c2bd0f675093fb593ba347b471749c0a0dbefdc75b6334a7b6e4c"

  def install
    system "make", "localmake"
    system "make", "all"

    # Install manually
    bin.install "ee"
    man1.install "ee.1"
  end
end
