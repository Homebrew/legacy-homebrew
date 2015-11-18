class GetFlashVideos < Formula
  desc "Download or play videos from various Flash-based websites"
  homepage "https://github.com/monsieurvideo/get-flash-videos"
  url "https://github.com/monsieurvideo/get-flash-videos/archive/1.25.90.tar.gz"
  sha256 "b6c3b3db558c5b373ef4e8162b2c0ac2ebf6696f8c1d4e261406671856610c57"

  bottle do
    cellar :any_skip_relocation
    sha256 "fca39d2474946ab2e10a9e361762c07524516ed2907e0cb9942fabca46ccca53" => :el_capitan
    sha256 "d60a64e719c7097b7caa0be8d7424d7019df4cd8bc4e09e8173ba0dfbf84758a" => :yosemite
    sha256 "13d00aa46643c8e2cd3e8b6fe10d39a999a20d740d4529c4316e4b0a639af6ab" => :mavericks
  end

  depends_on "rtmpdump"

  resource "Crypt::Blowfish_PP" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTBM/Crypt-Blowfish_PP-1.12.tar.gz"
    sha256 "714f1a3e94f658029d108ca15ed20f0842e73559ae5fc1faee86d4f2195fcf8c"
  end

  resource "LWP::Protocol" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/libwww-perl-6.13.tar.gz"
    sha256 "5fbd13eebd1933e5a203fceb2c1629efbccff3efc8fab6ec0285c79d0a95f8b2"
  end

  resource "Tie::IxHash" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz"
    sha256 "fabb0b8c97e67c9b34b6cc18ed66f6c5e01c55b257dcf007555e0b027d4caf56"
  end

  resource "WWW::Mechanize" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/WWW-Mechanize-1.75.tar.gz"
    sha256 "5310051feb66c6ef9f7a4c070c66ec6092932129fc9cd18bba009ce999b7930b"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV.prepend_create_path "PERL5LIB", lib/"perl5"
    system "make"
    (lib/"perl5").install "blib/lib/FlashVideo"

    bin.install "bin/get_flash_videos"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    chmod 0755, libexec/"bin/get_flash_videos"

    man1.install "blib/man1/get_flash_videos.1"
  end

  test do
    system bin/"get_flash_videos", "http://news.bbc.co.uk/2/hi/programmes/hardtalk/9560793.stm"
    File.exist? "BBC_-__Do_whatever_it_takes_to_get_him_to_talk.flv"
  end
end
