class LibvoAacenc < Formula
  homepage "http://opencore-amr.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/opencore-amr/vo-aacenc/vo-aacenc-0.1.2.tar.gz"
  sha1 "ac56325c05eba4c4f8fe2c5443121753f4d70255"

  bottle do
    cellar :any
    revision 1
    sha1 "ac00d35656c43e6ffa1286e433374fc9e2320c1a" => :yosemite
    sha1 "3c8fb5c15a89647e021c80ac2294c89437b4b195" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <vo-aacenc/cmnMemory.h>

      int main()
      {
        VO_MEM_INFO info; info.Size = 1;
        VO_S32 uid = 0;
        VO_PTR pMem = cmnMemAlloc(uid, &info);
        cmnMemFree(uid, pMem);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lvo-aacenc", "-o", "test"
    system "./test"
  end
end
