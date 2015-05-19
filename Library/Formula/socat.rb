class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.0.tar.gz"
  sha1 "c09ec6539647cebe8fccdfcf0f1ace1243231ec3"

  bottle do
    cellar :any
    sha1 "1dbd28a373b01b68aa18882f27a4ad82a75cdcd6" => :yosemite
    sha1 "af4f37fa4ac0083200f6ede2e740a35b69decc0e" => :mavericks
    sha1 "1e756f77d2956ceea9ea454d62ef1ae58e90d1ad" => :mountain_lion
  end

  depends_on 'readline'
  depends_on 'openssl'

  def install
    ENV.enable_warnings # -w causes build to fail
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
