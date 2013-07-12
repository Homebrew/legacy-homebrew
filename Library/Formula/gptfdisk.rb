require 'formula'

class Gptfdisk < Formula
  homepage 'http://www.rodsbooks.com/gdisk/'
  url 'http://downloads.sourceforge.net/project/gptfdisk/gptfdisk/0.8.7/gptfdisk-0.8.7.tar.gz'
  sha1 'a134cdf28d0130bc0d3e459c0098b9109d9d3fb6'

  depends_on 'popt'
  depends_on 'icu4c'

  def install
    system "make -f Makefile.mac"
    sbin.install ['gdisk','cgdisk','sgdisk','fixparts']
    man8.install ['gdisk.8','cgdisk.8','sgdisk.8','fixparts.8']
  end

  test do
    IO.popen("#{sbin}/gdisk", "w+") do |pipe|
      pipe.write("\n")
      assert_match /GPT fdisk \(gdisk\) version #{Regexp.escape(version)}/, pipe.read
    end
  end
end
