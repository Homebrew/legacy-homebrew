class Texapp < Formula
  desc "App.net client based on TTYtter"
  homepage "http://www.floodgap.com/software/texapp/"
  url "http://www.floodgap.com/software/texapp/dist0/0.6.10.txt"
  sha256 "e05fa2b3cdc90c79c8725141b3176a312d46251606431226f0754d96fb0b10fd"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "abf6784748570d0c546c674aa24e7d7a2109ee954c347c0915c3bc4cbb4b6c3f" => :el_capitan
    sha256 "ed0d063ffcf117a5b17502986ef5ad3d586e7919a693c0097439c87e76206413" => :yosemite
    sha256 "8cef1737778cfced3bc83985677f114a7877d6442fb520ea252d96b6dd504285" => :mavericks
  end

  depends_on "readline" => :optional

  resource "Term::ReadLine::TTYtter" do
    url "https://cpan.metacpan.org/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz"
    sha256 "ac373133cee1b2122a8273fe7b4244613d0eecefe88b668bd98fe71d1ec4ac93"
  end

  def install
    bin.install "#{version}.txt" => "texapp"

    if build.with? "readline"
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("Term::ReadLine::TTYtter").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
      bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
      chmod 0755, libexec/"bin/texapp"
    end
  end

  test do
    assert_match "trying to find cURL ...", pipe_output("#{bin}/texapp", "^C")
  end
end
