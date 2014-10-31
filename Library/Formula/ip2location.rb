require "formula"

class Ip2location < Formula
  homepage "http://www.ip2location.com"
  url "https://github.com/velikanov/ip2location/archive/v7.0.0.6.tar.gz"
  sha1 "ee2c0c86b142f52c0a93b0ef2e2712a5b2b9e35b"

  resource "sample-database" do
    url "http://www.ip2location.com/downloads/sample.bin.db1.zip"
    sha1 "8e1acd7f35a909b6d7bc7d482934050eb1167fa3"
  end

  def install
    lib.mkpath
    system "./configure", "--prefix=#{prefix}", "--include=#{include}"
    system "make"
    system "make", "install"

    (var/"IP2Location").install "country_test_ipv4_data.txt"

    legacy_data = Pathname.new "#{HOMEBREW_PREFIX}/share/IP2Location"
    legacy_data.mkpath unless legacy_data.exist? or legacy_data.symlink?

    resource("sample-database").stage {
      legacy_data.install "IP-COUNTRY-SAMPLE.BIN"
    }
  end

  test do
    ip2location_data = Pathname.new "#{var}/IP2Location"
    legacy_data = Pathname.new "#{HOMEBREW_PREFIX}/share/IP2Location"

    (testpath/'test.cpp').write <<-EOS.undent
      #include <stdio.h>
      #include <string.h>
      #include <IP2Location.h>
      int main() {
        FILE *f4;
        char ipAddress[30];
        char expectedCountry[3];
        int failed = 0;

        IP2Location *IP2Location4 = IP2Location_open("#{legacy_data}/IP-COUNTRY-SAMPLE.BIN");
        IP2LocationRecord *record4 = NULL;

        IP2Location_open_mem(IP2Location4, IP2LOCATION_SHARED_MEMORY);

        f4 = fopen("#{ip2location_data}/country_test_ipv4_data.txt", "r");

        while (fscanf(f4, "%s", ipAddress) != EOF) {
          fscanf(f4, "%s", expectedCountry);
          record4 = IP2Location_get_all(IP2Location4, ipAddress);

          if (record4 != NULL) {
            if (strcmp(expectedCountry, record4->country_short) != 0) {
              failed++;
            }

            IP2Location_free_record(record4);
          }
        }

        fclose(f4);
        IP2Location_close(IP2Location4);

        return failed;
      }
    EOS
    system ENV.cc, "test.cpp", "-lIP2Location", "-o", "test"
    system "./test"
  end
end
