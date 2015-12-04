class Mp3wrap < Formula
  desc "Wrap two or more mp3 files in a single large file"
  homepage "http://mp3wrap.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mp3wrap/mp3wrap/mp3wrap%200.5/mp3wrap-0.5-src.tar.gz"
  sha256 "1b4644f6b7099dcab88b08521d59d6f730fa211b5faf1f88bd03bf61fedc04e7"

  bottle do
    cellar :any
    sha256 "4e8f01653ab2067bcb7ed2716fdb864aac08b517c995839f6d3b942cb705504c" => :mavericks
    sha256 "ea4a05df9dc44f6fc5f9658fcc6694c0ec0c649a882bc97b3b37354de08f7d0f" => :mountain_lion
    sha256 "10128ee1f87efb4e7259c39c14633d16d1f6138f6bde064a50e66d3ba8427b1f" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    source = test_fixtures("test.mp3")
    system "#{bin}/mp3wrap", "#{testpath}/t.mp3", source, source
    assert File.exist? testpath/"t_MP3WRAP.mp3"
  end
end
