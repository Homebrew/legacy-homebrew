class Ttytter < Formula
  desc "Twitter command-line client"
  homepage "http://www.floodgap.com/software/ttytter/"
  url "http://www.floodgap.com/software/ttytter/dist2/2.1.00.txt"
  sha256 "86c6e7767c65e3179d4ed6368e27df5c4b200285207c3df3164c5a84a73517b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e420245d478de01c3af0d2eb6f4defffd41f797e2a1fdb2188fdfff0b6019138" => :el_capitan
    sha256 "97862d3f0921ae13a32b80726af34c95ac219a9803638d7ab1402918da1d5f35" => :yosemite
    sha256 "f6db877166218a340565eec1a85db1e24657f7cc560f77200f8a7df1034a6388" => :mavericks
  end

  depends_on "readline" => :optional

  resource "Term::ReadLine::TTYtter" do
    url "https://cpan.metacpan.org/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz"
    sha256 "ac373133cee1b2122a8273fe7b4244613d0eecefe88b668bd98fe71d1ec4ac93"
  end

  def install
    bin.install "#{version}.txt" => "ttytter"

    if build.with? "readline"
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("Term::ReadLine::TTYtter").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
      bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
      chmod 0755, libexec/"bin/ttytter"
    end
  end

  test do
    IO.popen("#{bin}/ttytter", "r+") do |pipe|
      assert_equal "-- using SSL for default URLs.", pipe.gets.chomp
      pipe.puts "^C"
      pipe.close_write
    end
  end
end
