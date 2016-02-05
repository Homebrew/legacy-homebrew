# jless (Jam Less) is Japan-ized Less.
# jless supports ISO 2022 code extension techniques and Japanese codes.

class Jless < Formula
  desc "Jless file pager supporting ISO2022"
  homepage "http://www.greenwoodsoftware.com/less/"
  url "http://ftp.de.debian.org/debian/pool/main/j/jless/jless_382-iso262.orig.tar.gz"
  version "382+iso262+ext03"
  sha256 "d33cc51f220647d015fd526b3782cde03c5d8b18c5233e6388a0047a70446fe7"

  [
    %w[258       961275c26c6f6ec2e04821d9d9d1b10505214b1f],
    %w[258-259   7256998c59f9743e61e83e9e5ebc5183e8eeb269],
    %w[259-260   56e5537fae516ee738b1512eed303f43ed0d4575],
    %w[260-261   3a889e178a32c3a273b89fd396976362a975f627],
    %w[261-262   d5cc92e5dcbfde26257eec5f126df5bf73779a89],
    %w[262.ext03 dc35204274ecf02da5f7ffb583da680ea6f4356c]
  ].each do |name, sha|
    patch do
      url "http://ftp.netbsd.org/pub/pkgsrc/distfiles/less-382-iso#{name}.patch.gz"
      sha1 sha
    end
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install binprefix=j manprefix=j"
  end

  def caveats
    "You may need to set the environment variable 'JLESSCHARSET' to japanese-utf8"
  end
end
