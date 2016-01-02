class Proj < Formula
  desc "PROJ.4, a Cartographic Projections Library"
  homepage "https://trac.osgeo.org/proj/"
  url "http://download.osgeo.org/proj/proj-4.9.2.tar.gz"
  sha256 "60bf9ad1ed1c18158e652dfff97865ba6fb2b67f1511bc8dceae4b3c7e657796"
  head "http://svn.osgeo.org/metacrs/proj/trunk/proj"

  bottle do
    sha256 "b38c33321502ff9d808f06e1f8ff932c0c2c2c832c121c61cd30d5cd98fbaf8e" => :el_capitan
    sha256 "8146548590a89b1c82a115594b282f6d6708067490dd8c2f83d1e0d8a03845c3" => :yosemite
    sha256 "d76df7d958194e3e71993de9496480f0ee636170251b50013f79628ae27c9888" => :mavericks
  end

  option "with-vdatum", "Install vertical datum files (~380 MB)"

  # The datum grid files are required to support datum shifting
  resource "datumgrid" do
    url "http://download.osgeo.org/proj/proj-datumgrid-1.5.zip"
    sha256 "723c4017d95d7a8abdf3bda4e18d3c15d79b00f9326d453da5fdf13f96c287db"
  end

  # Vertical datum files
  resource "usa_geoid2012" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid2012.zip"
    sha256 "afe49dc2c405d19a467ec756483944a3c9148e8c1460cb7e82dc8d4a64c4c472"
  end

  resource "usa_geoid2009" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid2009.zip"
    sha256 "1a232fb7fe34d2dad2d48872025597ac7696882755ded1493118a573f60008b1"
  end

  resource "usa_geoid2003" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid2003.zip"
    sha256 "1d15950f46e96e422ebc9202c24aadec221774587b7a4cd963c63f8837421351"
  end

  resource "usa_geoid1999" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid1999.zip"
    sha256 "665cd4dfc991f2517752f9db84d632b56bba31a1ed6a5f0dc397e4b0b3311f36"
  end

  resource "vertconc" do
    url "http://download.osgeo.org/proj/vdatum/vertcon/vertconc.gtx"
    sha256 "ecf7bce7bf9e56f6f79a2356d8d6b20b9cb49743701f81db802d979b5a01fcff"
  end

  resource "vertcone" do
    url "http://download.osgeo.org/proj/vdatum/vertcon/vertcone.gtx"
    sha256 "f6da1c615c2682ecb7adcfdf22b1d37aba2771c2ea00abe8907acea07413903b"
  end

  resource "vertconw" do
    url "http://download.osgeo.org/proj/vdatum/vertcon/vertconw.gtx"
    sha256 "de648c0f6e8b5ebfc4b2d82f056c7b993ca3c37373a7f6b7844fe9bd4871821b"
  end

  resource "egm96_15" do
    url "http://download.osgeo.org/proj/vdatum/egm96_15/egm96_15.gtx"
    sha256 "c02a6eb70a7a78efebe5adf3ade626eb75390e170bb8b3f36136a2c28f5326a0"
  end

  resource "egm08_25" do
    url "http://download.osgeo.org/proj/vdatum/egm08_25/egm08_25.gtx"
    sha256 "c18f20d1fe88616e3497a3eff993227371e1d9acc76f96253e8d84b475bbe6bf"
  end

  skip_clean :la

  fails_with :llvm do
    build 2334
  end

  def install
    resources.each do |r|
      if r.name == "datumgrid"
        (buildpath/"nad").install r
      elsif build.with? "vdatum"
        (share/"proj").install r
      end
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      45d15n 71d07w Boston, United States
      40d40n 73d58w New York, United States
      48d51n 2d20e Paris, France
      51d30n 7'w London, England
    EOS
    match = <<-EOS.undent
      -4887590.49\t7317961.48 Boston, United States
      -5542524.55\t6982689.05 New York, United States
      171224.94\t5415352.81 Paris, France
      -8101.66\t5707500.23 London, England
    EOS
    assert_equal match,
                 `#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test`
  end
end
