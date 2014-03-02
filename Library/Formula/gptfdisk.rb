require 'formula'

class Gptfdisk < Formula
  homepage 'http://www.rodsbooks.com/gdisk/'
  url 'https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/0.8.8/gptfdisk-0.8.8.tar.gz'
  sha1 '11f66ec2a67920368f7afe0c01a1cb8c3f2c527a'

  depends_on 'popt'
  depends_on 'icu4c'

  def install
    system "make -f Makefile.mac"
    sbin.install 'gdisk', 'cgdisk', 'sgdisk', 'fixparts'
    man8.install Dir['*.8']
  end

  test do
    IO.popen("#{sbin}/gdisk", "w+") do |pipe|
      pipe.write("\n")
      assert_match /GPT fdisk \(gdisk\) version #{Regexp.escape(version)}/, pipe.read
    end
  end
end
