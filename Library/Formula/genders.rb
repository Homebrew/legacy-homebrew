class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https://computing.llnl.gov/linux/genders.html"
  url "https://downloads.sourceforge.net/project/genders/genders/1.20-1/genders-1.20.tar.gz"
  sha256 "374ef2833ad53ea9ca4ccbabd7a66d77ab0b46785e299c0e64f95577eed96ac9"

  option "with-non-shortened-hostnames", "Allow non shortened hostnames that can include dots e.g. www.google.com"

  def install
    args = ["--prefix=#{prefix}"]

    args << "--with-non-shortened-hostnames" if build.with? "non-shortened-hostnames"

    system "./configure", *args
    system "make", "install"
  end
end
