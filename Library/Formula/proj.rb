require 'formula'

class Proj < Formula
  homepage 'http://trac.osgeo.org/proj/'
  url 'http://download.osgeo.org/proj/proj-4.9.1.tar.gz'
  sha1 '0bc63a41f1bdcff600d076c056f796007abf3f2f'
  head "http://svn.osgeo.org/metacrs/proj/trunk/proj/"

  option "with-vdatum", "Install vertical datum files (~380 MB)"

  bottle do
    revision 2
    sha1 "66efa5cca3047ce7cfa8414163c92a2f92f3aed9" => :yosemite
    sha1 "8cf4680113ab1acf4251d8310b1f2e7a5231b150" => :mavericks
    sha1 "57c74a55e948b3cb8565faa360a754e63a294084" => :mountain_lion
  end

  # The datum grid files are required to support datum shifting
  resource 'datumgrid' do
    url 'http://download.osgeo.org/proj/proj-datumgrid-1.5.zip'
    sha1 '4429ba1a8c764d5c0e6724d868f6874f452f7440'
  end

  # Vertical datum files
  resource "usa_geoid2012" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid2012.zip"
    sha1 "07359705877c2af2be3508e7905813f20ed4ba20"
  end

  resource "usa_geoid2009" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid2009.zip"
    sha1 "7ba5ff82dacf1dd56d666dd3ee8470e86946a479"
  end

  resource "usa_geoid2003" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid2003.zip"
    sha1 "d83c584c936045c9f6c51209e4726449eb5d1c17"
  end

  resource "usa_geoid1999" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid1999.zip"
    sha1 "1374f67dced7350783458431d916d1d8934cb187"
  end

  resource "vertconc" do
    url "http://download.osgeo.org/proj/vdatum/vertcon/vertconc.gtx"
    sha1 "9ce4b68f3991ed54316c0d534a3c5744b55b5cd2"
  end

  resource "vertcone" do
    url "http://download.osgeo.org/proj/vdatum/vertcon/vertcone.gtx"
    sha1 "265aa34c14ed049441c212aeda3cada9281e6ec7"
  end

  resource "vertconw" do
    url "http://download.osgeo.org/proj/vdatum/vertcon/vertconw.gtx"
    sha1 "379b4852b837ca4186f089f35d097521bf63ed1f"
  end

  resource "egm96_15" do
    url "http://download.osgeo.org/proj/vdatum/egm96_15/egm96_15.gtx"
    sha1 "5396c20a37c63abb1191ab44a164e2e2106dcb6c"
  end

  resource "egm08_25" do
    url "http://download.osgeo.org/proj/vdatum/egm08_25/egm08_25.gtx"
    sha1 "cddabcb9f9000afa869bdbfeb7bcf13521647fa7"
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
    assert_match "103.69\t" "205.85\n", pipe_output("proj +proj=tmerc +ellps=WGS84 +units=km +lon_0=-121.15 +lat_0=34.15", "-120 36", 0)
  end
end
