require 'formula'

class Lockrun < Formula
  homepage 'http://unixwiz.net/tools/lockrun.html'
  url 'http://unixwiz.net/tools/lockrun.c'
  version '1.1.3'
  sha1 '513e586884b9a7112b7da3acf53e75c84e28cda9'

  bottle do
    cellar :any
    sha1 "d157639542e6b17bb4881cbde0aef98594da7764" => :yosemite
    sha1 "c28e303637b7f156d01c3fc132294c863c2f60c2" => :mavericks
    sha1 "57ee54e2f8157acf5f2b76cd869ca9dd1b97c777" => :mountain_lion
  end

  def install
    system "#{ENV.cc} #{ENV.cflags} lockrun.c -o lockrun"
    bin.install "lockrun"
  end
end
