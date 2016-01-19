class Pound < Formula
  desc "Reverse proxy, load balancer and HTTPS front-end for web servers"
  homepage "http://www.apsis.ch/pound"
  url "http://www.apsis.ch/pound/Pound-2.7.tgz"
  sha256 "cdfbf5a7e8dc8fbbe0d6c1e83cd3bd3f2472160aac65684bb01ef661c626a8e4"

  bottle do
    sha256 "aebc9ef8e97b4995923752811da180e83adcf2ef55d1809d7dc51b44a73d1b02" => :yosemite
    sha256 "74c64dba8bf19737259ad996f15bbf66bb2bcd24e71ef206ec4b0e6bf1042a70" => :mavericks
    sha256 "fa872353daeab3c6386f947b74c43932f66a20acf230575dec3afaf835edc22b" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "pcre"
  depends_on "gperftools" => :recommended

  def install
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
