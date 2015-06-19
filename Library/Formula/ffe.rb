class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "http://ff-extractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ff-extractor/ff-extractor/0.3.4/ffe-0.3.4.tar.gz"
  sha1 "9e0f435568a65ef552d71e1a10a12f0627e1ccf9"

  bottle do
    cellar :any
    sha1 "7410c7c429880b06631ad40ae2de9c327a753a2b" => :yosemite
    sha1 "ae4d3ab7b308b788b26051ae5df452a473cbc573" => :mavericks
    sha1 "d58fb6890e7732247a1a99fb12a4dd131c7cabd3" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"source").write "EArthur Guinness   25"
    (testpath/"test.rc").write <<-EOS.undent
      structure personel_fix {
        type fixed
        record employee {
          id 1 E
          field EmpType 1
          field FirstName 7
          field LastName  11
          field Age 2
        }
      }
      output default {
        record_header "<tr>"
        data "<td>%t</td>"
        record_trailer "</tr>"
        no-data-print no
      }
    EOS

    system "#{bin}/ffe", "-c", "test.rc", "source"
  end
end
