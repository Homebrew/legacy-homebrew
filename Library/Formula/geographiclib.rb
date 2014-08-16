require "formula"
class Geographiclib < Formula
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.37.tar.gz"
  sha1 "d18d0c94824fb303ce8942d622bdef78833108cd"

  depends_on "cmake" => :build

  def install
    mkdir "build"
    chdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # This just replicates a subset of the cmake tests (namely, those
    # that don't depend on additional data files).  Note however that
    # the results are not checked.  For this, add "make test" to the
    # installation commands.

    system "GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
    system "GeoConvert", "-d", "--input-string", "38smb"
    system "GeoConvert", "-p", "-2", "--input-string", "30d30'30\" 30.50833"
    system "GeoConvert", "-p", "9", "--input-string", "0 179.99999999999998578"
    system "GeodSolve", "-i", "-p", "0", "--input-string", "40.6 -73.8 49d01'N 2d33'E"
    system "GeodSolve", "-p", "0", "--input-string", "40d38'23\"N 073d46'44\"W 53d30' 5850e3"
    system "GeodSolve", "-i", "-p", "0", "-e", "6.4e6", "-1/150", "--input-string", "0.07476 0 -0.07476 180"
    system "GeodSolve", "-i", "-p", "0", "-e", "6.4e6", "-1/150", "--input-string", "0.1 0 -0.1 180"
    system "GeodSolve", "-i", "--input-string", "36.493349428792 0 36.49334942879201 .0000008"
    system "GeodSolve", "-p", "0", "--input-string", "0.01777745589997 30 0 10e6"
    system "GeodSolve", "-i", "--input-string", "88.202499451857 0 -88.202499451857 179.981022032992859592"
    system "GeodSolve", "-i", "--input-string", "89.262080389218 0 -89.262080389218 179.992207982775375662"
    system "GeodSolve", "-i", "--input-string", "89.333123580033 0 -89.333123580032997687 179.99295812360148422"
    system "GeodSolve", "-i", "--input-string", "56.320923501171 0 -56.320923501171 179.664747671772880215"
    system "GeodSolve", "-i", "--input-string", "52.784459512564 0 -52.784459512563990912 179.634407464943777557"
    system "GeodSolve", "-i", "--input-string", "48.522876735459 0 -48.52287673545898293 179.599720456223079643"
    system "GeodSolve", "-i", "-e", "89.8", "-1.83", "-p", "1", "--input-string", "0 0 -10 160"
    system "GeodSolve", "-i", "-e", "89.8", "-1.83", "-p", "1", "--input-string", "0 0 -10 160", "-E"
    system "Planimeter", "--input-string", "89 0;89 90;89 180;89 270"
    system "Planimeter", "-r", "--input-string", "-89 0;-89 90;-89 180;-89 270"
    system "Planimeter", "--input-string", "0 -1;-1 0;0 1;1 0"
    system "Planimeter", "--input-string", "90 0; 0 0; 0 90"
    system "Planimeter", "-l", "--input-string", "90 0; 0 0; 0 90"
    system "Planimeter", "-p", "8", "--input-string", "9 -0.00000000000001;9 180;9 0"
    system "Planimeter", "-p", "8", "--input-string", "9  0.00000000000001;9 0;9 180"
    system "Planimeter", "-p", "8", "--input-string", "9  0.00000000000001;9 180;9 0"
    system "Planimeter", "-p", "8", "--input-string", "9 -0.00000000000001;9 0;9 180"
    system "ConicProj", "-a", "40d58", "39d56", "-l", "77d45W", "-r", "--input-string", "220e3 -52e3"
    system "ConicProj", "-a", "0", "0", "-e", "6.4e6", "-0.5", "-r", "--input-string", "0 8605508"
    system "ConicProj", "-c", "-30", "-30", "--input-string", "-30 0"
    system "ConicProj", "-r", "-c", "0", "0", "--input-string", "1113195 -1e10"
    system "ConicProj", "-r", "-c", "0", "0", "--input-string", "1113195 inf"
    system "ConicProj", "-r", "-c", "45", "45", "--input-string", "0 -1e100"
    system "ConicProj", "-r", "-c", "45", "45", "--input-string", "0 -inf"
    system "ConicProj", "-r", "-c", "90", "90", "--input-string", "0 -1e150"
    system "ConicProj", "-r", "-c", "90", "90", "--input-string", "0 -inf"
    system "CartConvert", "-e", "6.4e6", "1/100", "-r", "--input-string", "10e3 0 1e3"
    system "CartConvert", "-e", "6.4e6", "-1/100", "-r", "--input-string", "1e3 0 10e3"
    system "TransverseMercatorProj", "-k", "1", "--input-string", "90 75"
    system "TransverseMercatorProj", "-k", "1", "-r", "--input-string", "0 10001965.7293127228"
  end
end
