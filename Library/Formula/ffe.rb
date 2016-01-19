class Ffe < Formula
  desc "Parse flat file structures and print them in different formats"
  homepage "http://ff-extractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ff-extractor/ff-extractor/0.3.6/ffe-0.3.6.tar.gz"
  sha256 "f508a0698d9ebdfefd41f150634ee97b2c4b3831577dd27d0156893d0c5f0b3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "3aa23ef80b9b7585ae611958c0554aedf0551c2a145350c82684fc2e84542eda" => :el_capitan
    sha256 "3ad5ef87fbf6d04ab007ec9417ba4dbca488209ae746bc614187db07229b3183" => :yosemite
    sha256 "7fef4388c75c233b12ba2a850dd6bbd3b843032b63e13455d442cb8211ca921e" => :mavericks
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
