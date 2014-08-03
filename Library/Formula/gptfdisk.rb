require 'formula'

class Gptfdisk < Formula
  homepage 'http://www.rodsbooks.com/gdisk/'
  url 'https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/0.8.10/gptfdisk-0.8.10.tar.gz'
  sha1 '1708e232220236b6bdf299b315e9bc2205c01ba5'

  depends_on 'popt'
  depends_on 'icu4c'

  def install
    system "make -f Makefile.mac"
    sbin.install 'gdisk', 'cgdisk', 'sgdisk', 'fixparts'
    man8.install Dir['*.8']
  end

  test do
    assert_match /GPT fdisk \(gdisk\) version #{Regexp.escape(version)}/,
                 pipe_output("#{sbin}/gdisk", "\n")
  end
end
