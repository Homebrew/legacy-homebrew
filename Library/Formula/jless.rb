# jless (Jam Less) is Japan-ized Less.
# jless supports ISO 2022 code extension techniques and Japanese codes.

class Jless < Formula
  desc "Jless file pager supporting ISO2022"
  homepage "http://www.greenwoodsoftware.com/less/"
  url "http://ftp.de.debian.org/debian/pool/main/j/jless/jless_382-iso262.orig.tar.gz"
  version "382+iso262+ext03"
  sha256 "d33cc51f220647d015fd526b3782cde03c5d8b18c5233e6388a0047a70446fe7"

  [
    %w[258       ecbbbf7a06d221021dae9f74862e2c41c91ded118c215687c13f5cb95d22f975],
    %w[258-259   378c35f56fc40236994a869b9ffe18935611bd2ee6be0087f152c782214c4eb1],
    %w[259-260   d3fab30dcb15a0b2d6d491222ca405ff23a73f7076e865fe64a01ab0ed3b6a8a],
    %w[260-261   e79da33e7756e5b5e9eddf7a39d22f149f52e74d7b06a8ef3b6ac094ed3c6e71],
    %w[261-262   4e79964da0bad15a5b8178b4ddab684cfdc3a7616ad140931e9ca7fca0d693c8],
    %w[262.ext03 5fb573a21db13bd4e1fd8b08163064f93a7f12d037a651503d2e55ef1ffc9672]
  ].each do |name, sha|
    patch do
      url "http://ftp.netbsd.org/pub/pkgsrc/distfiles/less-382-iso#{name}.patch.gz"
      sha256 sha
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
