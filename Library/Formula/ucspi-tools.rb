class UcspiTools < Formula
  homepage "https://github.com/younix/ucspi/blob/master/README.md"
  url "https://github.com/younix/ucspi/archive/v1.2.tar.gz"
  sha1 "38a708efd6d72e0d9d077efb15477763bdea39b0"

  depends_on "pkg-config" => :build
  depends_on "ucspi-tcp"
  depends_on "libressl"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"http.sh").write <<-EOL
#!/bin/sh
printf "GET / HTTP/1.1\\r\\n" >&6
printf "Host: github.com\\r\\n" >&6
printf "\\r\\n" >&6
cat - <&7
EOL
    chmod 0755, testpath/"http.sh"
    out = shell_output("tcpclient github.com 443 #{bin}/tlsc -CH #{testpath}/http.sh", 1)
    assert_match %r{HTTP/1.1 200 OK}, out
    assert_match /Status: 200 OK/, out
    assert_match /<!DOCTYPE html>/, out
  end
end
