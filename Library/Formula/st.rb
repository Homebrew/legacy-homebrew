class St < Formula
  desc "Statistics from the command-line"
  homepage "https://github.com/nferraz/st"
  url "https://github.com/nferraz/st/archive/v1.1.2.tar.gz"
  sha256 "46a3d10995a910870d07550ed86c2979a46523059bed4067e9a49a403be331c8"

  bottle do
    sha256 "d2654ec5ed18e1fcfe41e8c34bfc5bda5b134698f9f7eaf1b8d1fb73e6603f49" => :yosemite
    sha256 "bee18d7a80cf6858c025206472913e6dc39512459a0543462bdff7bee689b1c0" => :mavericks
    sha256 "01fecae7c00ca950cd36ae14efd132027269687b59ec21d79d3ae9800617839a" => :mountain_lion
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl/"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "install"
    inreplace libexec/"bin/st", "perl -T", "perl"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", :PERL5LIB => ENV["PERL5LIB"]
  end

  test do
    (testpath/"test.txt").write((1..100).map(&:to_s).join("\n"))
    assert_equal "5050", pipe_output("#{bin}/st --sum test.txt").chomp
  end
end
