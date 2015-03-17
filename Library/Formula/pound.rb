class Pound < Formula
  homepage "http://www.apsis.ch/pound"
  url "http://www.apsis.ch/pound/Pound-2.7.tgz"
  sha256 "cdfbf5a7e8dc8fbbe0d6c1e83cd3bd3f2472160aac65684bb01ef661c626a8e4"

  depends_on "openssl"
  depends_on "pcre"
  depends_on "google-perftools" => :recommended

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].lib}"

    system "./configure", "--prefix=#{prefix}", "--disable-tcmalloc"
    system "make"
    # Manual install to get around group issues
    sbin.install "pound", "poundctl"
    man8.install "pound.8", "poundctl.8"
  end

  test do
    (testpath/"pound.cfg").write <<-EOS.undent
      ListenHTTP
        Address 1.2.3.4
        Port    80
        Service
          HeadRequire "Host: .*www.server0.com.*"
          BackEnd
            Address 192.168.0.10
            Port    80
          End
        End
      End
    EOS

    system "#{sbin}/pound", "-f", "#{testpath}/pound.cfg", "-c"
  end
end
