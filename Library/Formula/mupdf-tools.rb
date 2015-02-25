class MupdfTools < Formula
  homepage "http://mupdf.com"
  url "http://mupdf.com/downloads/mupdf-1.6-source.tar.gz"
  sha1 "491d7a3b131589791c7df6dd8161c6bfe41ce74a"

  depends_on :macos => :snow_leopard
  depends_on "openssl"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal("Homebrew test.\n\n\f\n", shell_output("#{bin}/mudraw -t #{pdf}"))

    expected = <<-EOS.undent
      
      PDF-1.6

      Pages: 1
      
      Retrieving info from pages 1-1...
      Mediaboxes (1):
      	1	(3 0 R):	[ 0 0 500 800 ]
      
      Fonts (1):
      	1	(3 0 R):	Type1 'Helvetica' (5 0 R)
      
    EOS

    assert_match(expected, shell_output("mutool info #{pdf}"))
  end
end
