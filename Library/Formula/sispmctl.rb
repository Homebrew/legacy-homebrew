 require "formula"

 class Sispmctl < Formula
   desc "Control Gembird SIS-PM programmable power outlet strips"
   homepage "http://sispmctl.sourceforge.net/"
   url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-3.1/sispmctl-3.1.tar.gz"
   sha256 "e9a99cc81ef0a93f3484e5093efd14d93cc967221fcd22c151f0bea32eb91da7"

   depends_on "libusb-compat"

   def install
     system "./configure", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
     system "make", "install"
   end
 end
