require 'formula'

class Primer3 < Formula
  homepage 'http://primer3.sourceforge.net/'
  url 'https://sourceforge.net/projects/primer3/files/primer3/2.3.4/primer3-2.3.4.tar.gz'
  sha1 '850d8e5cfbe84cdf3e4955a3974a6531a8ac6516'

  def install
    cd "src" do
      system "make all"
      bin.install %w(primer3_core ntdpal oligotm long_seq_tm_test)
    end
  end
end
