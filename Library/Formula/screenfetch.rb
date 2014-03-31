require "formula"

class Screenfetch < Formula
  homepage "http://git.silverirc.com/cgit.cgi/screenfetch.git"
  url "http://git.silverirc.com/cgit.cgi/screenfetch.git/snapshot/screenfetch-3.2.2.tar.bz2"
  sha1 "29ec0d68b2799a946dc75b390d96e5f1b2bb8aaf"
  head 'git://git.silverirc.com/screenfetch.git', :shallow => false

  bottle do
    cellar :any
    sha1 "a0af0c7172066ca31cf6eb542a4e7b642dd79dc7" => :mavericks
    sha1 "5ee15d688ee29db874a8171869bf0d8c970d8458" => :mountain_lion
    sha1 "ae7d892faa753aca39548ad14a5f949216c76051" => :lion
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
