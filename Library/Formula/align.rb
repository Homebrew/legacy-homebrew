require 'formula'

class Align < Formula
  homepage 'http://www.cs.indiana.edu/~kinzler/align/'
  url 'http://www.cs.indiana.edu/~kinzler/align/align-1.7.2.tgz'
  sha1 '6cae78d7df4d0a4aae654c37d68b9501810d9bf0'

  def install
    system 'make', 'install', "BINDIR=#{bin}"
  end

  test do
    IO.popen(bin/"align", "w+") do |pipe|
      pipe.write "1 1\n12 12\n"
      pipe.close_write
      assert_equal " 1  1\n12 12\n", pipe.read
    end
  end
end
