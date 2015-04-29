class Memtester < Formula
  homepage "http://pyropus.ca/software/memtester/"
  url "http://pyropus.ca/software/memtester/old-versions/memtester-4.3.0.tar.gz"
  sha256 "f9dfe2fd737c38fad6535bbab327da9a21f7ce4ea6f18c7b3339adef6bf5fd88"

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALLPATH", prefix
      s.gsub! "man/man8", "share/man/man8"
    end
    inreplace "conf-ld", " -s", ""
    system "make", "install"
  end

  test do
    system bin/"memtester", "1", "1"
  end
end
