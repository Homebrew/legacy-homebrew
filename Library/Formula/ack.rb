class Ack < Formula
  desc "Search tool like grep, but optimized for programmers"
  homepage "http://beyondgrep.com/"
  url "http://beyondgrep.com/ack-2.14-single-file"
  version "2.14"
  sha256 "1d203cfbc52ce8f49e3992be1cd3e4d7d5dfb7daa3739e8628aa9858ccc5b9df"

  head "https://github.com/petdance/ack2.git", :branch => "dev"

  devel do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/ack-2.15_01.tar.gz"
    sha256 "dfd1df3def5d3b16af8a7c585fc8954362d4f2b097891919490c89fdb484fd83"
    version "2.15-01"
  end

  bottle :unneeded

  resource "File::Next" do
    url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/File-Next-1.12.tar.gz"
    sha256 "cc3afd8eaf6294aba93b8152a269cc36a9df707c6dc2c149aaa04dabd869e60a"
  end

  def install
    if build.stable?
      bin.install "ack-#{version}-single-file" => "ack"
      system "pod2man", "#{bin}/ack", "ack.1"
      man1.install "ack.1"
    else
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV.prepend_path "PERL5LIB", libexec/"lib"

      resource("File::Next").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end

      system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
      system "make"

      libexec.install "ack"
      chmod 0755, libexec/"ack"
      (libexec/"lib").install "blib/lib/App"
      (bin/"ack").write_env_script("#{libexec}/ack", :PERL5LIB => ENV["PERL5LIB"])
      man1.install "blib/man1/ack.1"
    end
  end

  test do
    assert_equal "foo bar\n", pipe_output("#{bin}/ack --noenv --nocolor bar -",
                                          "foo\nfoo bar\nbaz")
  end
end
