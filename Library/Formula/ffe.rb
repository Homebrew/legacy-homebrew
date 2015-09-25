class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "http://ff-extractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ff-extractor/ff-extractor/0.3.5/ffe-0.3.5.tar.gz"
  sha256 "5ed5b4bf04bd8e2e438d8c37d3cec8ec681844b5318da8ac14565838c19c41da"

  bottle do
    cellar :any
    sha256 "82a0a0253d6a099960568fd911ef50f12dca2c5dca8a0798ae92858b4f0f65a4" => :yosemite
    sha256 "65f6f6b4c6facbb2adbe08519835273451ea374150d75aad7a60572886b828e9" => :mavericks
    sha256 "b97b84f0cbdcbee2266728434b5edbdacd54dc1b8d65095327e06a32c05e1799" => :mountain_lion
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
