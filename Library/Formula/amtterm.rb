class Amtterm < Formula
  desc "Serial-over-LAN (sol) client for Intel AMT"
  homepage "https://www.kraxel.org/blog/linux/amtterm/"
  url "https://www.kraxel.org/releases/amtterm/amtterm-1.4.tar.gz"
  sha256 "e10af2b02dbf66fb24abd292b9ddc6d86b31eea09887da5cb0eb8fb2ee900e21"

  head "git://git.kraxel.org/amtterm"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cea74bd49ac89a3a6eb3387749bccb08f263f837943bac72bde30f10c1320df" => :el_capitan
    sha256 "39d3fe96eceb64eb9ac76e114a3b16ee44edb461117d4c5ec05aac875f18f4c2" => :yosemite
    sha256 "35a6a905a27ca56c505aeea83538d874c1d184be55c68dae67842c6588960b3c" => :mavericks
    sha256 "38c350c1295d79e7c9cb6c78e7ec788139c9228f0130ffe2804971b0c8419799" => :mountain_lion
  end

  resource "SOAP::Lite" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/SOAP-Lite-1.11.tar.gz"
    sha256 "e4dee589ef7d66314b3dc956569b2541e0b917e834974e078c256571b6011efe"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("SOAP::Lite").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "make", "prefix=#{prefix}", "install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system "#{bin}/amtterm", "-h"
  end
end
