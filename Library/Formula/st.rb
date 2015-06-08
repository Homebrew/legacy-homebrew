class St < Formula
  desc "Statistics from the command-line"
  homepage "https://github.com/nferraz/st"
  url "https://github.com/nferraz/st/archive/v1.1.1.tar.gz"
  sha256 "fbfb0680e15448efccc6c6c83e4ae2f4c6a24d12c753444bffbd099632fa70c6"

  bottle do
    sha256 "12c6eccd64e7607dbaf7e3f18d3434957047e348e8d7a901352aae46442387c7" => :yosemite
    sha256 "1e38e3d700ba13981b45c54de2cb3f820bb5addf0dca6cae5fabd4418b3a7ad2" => :mavericks
    sha256 "77dbba21e74dcbddbf9a3f890f63b5416be9512f94bd4f7a694f8f5339ffd373" => :mountain_lion
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
