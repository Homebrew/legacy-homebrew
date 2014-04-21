require 'formula'

class Jsmin < Formula
  homepage 'http://www.crockford.com/javascript/jsmin.html'
  url 'https://github.com/douglascrockford/JSMin/archive/1bf6ce5f74a9f8752ac7f5d115b8d7ccb31cfe1b.tar.gz'
  version '2013-03-29'
  sha1 '8330fa182c283d5cc3fefcfb412bba662c0e2ee9'

  def install
    system ENV.cc, 'jsmin.c', '-o', 'jsmin'
    bin.install 'jsmin'
  end

  test do
    IO.popen("#{bin}/jsmin", "w+") do |pipe|
      pipe.puts "var i = 0; // comment"
      pipe.close_write
      assert_equal "\nvar i=0;", pipe.read
    end
  end
end
