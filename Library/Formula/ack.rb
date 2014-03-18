require 'formula'

class Ack < Formula
  homepage 'http://beyondgrep.com/'
  url 'http://beyondgrep.com/ack-2.12-single-file'
  sha1 '667b5f2dd83143848a5bfa47f7ba848cbe556e93'
  version '2.12'

  def install
    bin.install "ack-#{version}-single-file" => "ack"
    system "pod2man", "#{bin}/ack", "ack.1"
    man1.install "ack.1"
  end

  test do
    IO.popen("#{bin}/ack --noenv --nocolor bar -", "w+") do |pipe|
      pipe.write "foo\nfoo bar\nbaz"
      pipe.close_write
      assert_equal "foo bar\n", pipe.read
    end
  end
end
