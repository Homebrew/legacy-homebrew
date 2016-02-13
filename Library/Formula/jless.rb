# jless (Jam Less) is Japan-ized Less.
# jless supports ISO 2022 code extension techniques and Japanese codes.

class Jless < Formula
  desc "Jless file pager supporting ISO2022"
  homepage "http://www.greenwoodsoftware.com/less/"
  url "http://ftp.de.debian.org/debian/pool/main/j/jless/jless_382-iso262.orig.tar.gz"
  version "382+iso262+ext03"
  sha256 "d33cc51f220647d015fd526b3782cde03c5d8b18c5233e6388a0047a70446fe7"

  bottle do
    revision 1
    sha256 "00d5e6a985a6692c51f9c3b81e9ab954a2a2e8adc75861423e7830c6d46575d8" => :el_capitan
    sha256 "a7a470e7de19322dd2d4fb3e8b2be38cbc340936771aa00864a800f79e107b54" => :yosemite
    sha256 "614093a58873090cc70f51e5e0ff0fb7b3ee76214c619879258679502c9ee750" => :mavericks
  end

  [
    %w[258       0681485f47237aeee42a34bbf0ab55215933c7713d1be80ac202a31c7a6fdc31],
    %w[258-259   845bb97f407727febd4ee4014618715884bf393d1531089e18faf4e895e19cec],
    %w[259-260   e81a5de1fdc276cf0f189c674f37459cf1a7314ac1b804c077e23c519df87ec8],
    %w[260-261   b595378ae65a5a7256df3b6279d755d6fdce66ab6ea0bba4f51eeb9ee0307c03],
    %w[261-262   e7249de419acc3b8c4a11bed376d778711fd031887d0df0624d62a6d07356842],
    %w[262.ext03 82fb77f21ea1f3281224fcbfad073aeab12fb40d6623c9b40698be952401f821]
  ].each do |name, sha|
    patch do
      url "https://ftp.netbsd.org/pub/pkgsrc/distfiles/less-382-iso#{name}.patch.gz"
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
