require 'formula'

class Align < Formula
  homepage 'http://www.cs.indiana.edu/~kinzler/align/'
  url 'http://www.cs.indiana.edu/~kinzler/align/align-1.7.3.tgz'
  sha1 'fca5e53a7a3a95e740e7d12941f4edbee78ca084'

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
