class Unrtf < Formula
  homepage "https://www.gnu.org/software/unrtf/"
  url "http://ftpmirror.gnu.org/unrtf/unrtf-0.21.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/unrtf/unrtf-0.21.9.tar.gz"
  sha256 "22a37826f96d754e335fb69f8036c068c00dd01ee9edd9461a36df0085fb8ddd"

  head "http://hg.savannah.gnu.org/hgweb/unrtf/", :using => :hg

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.rtf").write <<-'EOS'.undent
      {\rtf1\ansi
      {\b hello} world
      }
    EOS
    expected = <<-EOS.undent
      <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
      <html>
      <head>
      <meta http-equiv="content-type" content="text/html; charset=utf-8">
      <!-- Translation from RTF performed by UnRTF, version #{version} -->
      </head>
      <body><b>hello</b> world</body>
      </html>
    EOS
    assert_equal expected, shell_output("#{bin}/unrtf --html test.rtf")
  end
end
