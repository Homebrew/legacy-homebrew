require 'formula'

class Cbmbasic < Formula
  homepage 'http://cbmbasic.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cbmbasic/cbmbasic/1.0/cbmbasic-1.0.tgz'
  sha1 '54564daa7f28be98b03ae7dd1eece9e5439c95c3'

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}"
    bin.install 'cbmbasic'
  end

  test do
    IO.popen("#{bin}/cbmbasic", "w+") do |pipe|
      pipe.write("PRINT 1\n")
      pipe.close_write
      assert_match /READY.\r\n 1/, pipe.read
    end
  end
end
