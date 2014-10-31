require "formula"

class Ip2location < Formula
  homepage "http://www.ip2location.com"
  url "https://github.com/velikanov/ip2location/archive/v7.0.0.4.tar.gz"
  sha1 "1c84fcec378c3a833f14294ed221cf6e9ed38af4"

  def install
    lib.mkpath
    system "./configure", "--prefix=#{prefix}", "--include=#{include}"
    system "make"
    system "make", "install"

    (var/"IP2Location").install "country_test_ipv4_data.txt"

    legacy_data = Pathname.new "#{HOMEBREW_PREFIX}/share/IP2Location"
    legacy_data.mkpath unless legacy_data.exist? or legacy_data.symlink?
  end

  test do
    system "curl", "-O", "http://www.ip2location.com/downloads/sample.bin.db1.zip"
    system "unzip", "-o", "sample.bin.db1.zip"

    ip2location_data = Pathname.new "#{var}/IP2Location"

    legacy_data = Pathname.new "#{HOMEBREW_PREFIX}/share/IP2Location"
    legacy_data.install "IP-COUNTRY-SAMPLE.BIN"

    (testpath/'test.cpp').write <<-EOS.undent
      #include <stdio.h>
      #include <string.h>
      #include <IP2Location.h>
      int main() {
        FILE *f4;
        char ipAddress[30];
        char expectedCountry[3];
        int failed = 0;
        int test_num = 1;

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
            test_num++;
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
