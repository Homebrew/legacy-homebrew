class Daq < Formula
  desc "Network intrusion prevention and detection system"
  homepage "https://www.snort.org/"
  url "https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz"
  sha256 "b40e1d1273e08aaeaa86e69d4f28d535b7e53bdb3898adf539266b63137be7cb"

  bottle do
    cellar :any
    sha256 "02d198f42f56471feaf127824230d7ea752490b3c7f5a34f8b50ff0a85062f01" => :yosemite
    sha256 "8ce4fbbbb9f6189f6ee51d3223a81ebc7ea76069353bd284822989d6ccc364a5" => :mavericks
    sha256 "bced15005e13eaa11ec6d47afbb1137f61231a191fb05a295e2762cc6cc8ef29" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <daq.h>
      #include <stdio.h>

      int main()
      {
        DAQ_Module_Info_t* list;
        int size = daq_get_module_list(&list);
        daq_free_module_list(list, size);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ldaq", "-o", "test"
    system "./test"
  end
end
