class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "http://www.aqbanking.de/"
  head "http://devel.aqbanking.de/svn/aqbanking/trunk"
  url "http://www2.aquamaniac.de/sites/download/download.php?package=03&release=118&file=01&dummy=aqbanking-5.5.1.tar.gz"
  sha256 "238f17d27d86e0cef239479c4be152cb98f5be9d6b87fca38741d32e762faddf"

  bottle do
    sha1 "285f830f8112289906fac106fc0e489aa13494f0" => :yosemite
    sha1 "ef66dfa1649ce43a0773aa9649168d02b23884a7" => :mavericks
    sha1 "53b0094bae8278c3305925126749d3fa27b907af" => :mountain_lion
  end

  depends_on "gwenhywfar"
  depends_on "libxmlsec1"
  depends_on "libxslt"
  depends_on "libxml2"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "pkg-config" => :build
  depends_on "ktoblzcheck" => :recommended

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cli",
                          "--with-gwen-dir=#{HOMEBREW_PREFIX}"
    system "make", "check"
    system "make", "install"
  end

  test do
    ENV["TZ"] = "UTC"
    context = "balance.ctx"
    (testpath/context).write <<-EOS.undent
    accountInfoList {
      accountInfo {
        char bankCode="110000000"
        char bankName="STRIPE TEST BANK"
        char accountNumber="000123456789"
        char accountName="demand deposit"
        char iban="US44110000000000123456789"
        char bic="BYLADEM1001"
        char owner="JOHN DOE"
        char currency="USD"
        int  accountType="0"
        int  accountId="2"

        statusList {
          status {
            int  time="1388664000"

            notedBalance {
              value {
                char value="123456%2F100"
                char currency="USD"
              } #value

              int  time="1388664000"
            } #notedBalance
          } #status

          status {
            int  time="1388750400"

            notedBalance {
              value {
                char value="132436%2F100"
                char currency="USD"
              } #value

              int  time="1388750400"
            } #notedBalance
          } #status
        } #statusList

      } # accountInfo
    } # accountInfoList
    EOS
    assert_match /^Account\s+110000000\s+000123456789\s+STRIPE TEST BANK\s+03.01.2014\s+12:00\s+1324.36\s+USD\s+$/, shell_output("#{bin}/aqbanking-cli listbal -c #{context}")
  end
end
