require 'formula'

class Rolldice < Formula
  homepage 'https://github.com/sstrickl/rolldice'
  url 'https://github.com/sstrickl/rolldice/archive/v1.14.tar.gz'
  sha1 '56d1abbf6d84b3392f51c2c5a25c7227c2835c5b'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "rolldice"
    man6.install gzip("rolldice.6")
  end

  test do
    output = `#{bin}/rolldice -s 1x2d6`
    assert output.include?("Roll #1")
    assert_equal 0, $?.exitstatus
  end
end
