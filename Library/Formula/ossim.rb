class Ossim < Formula
  desc "OSSIM is a powerful suite of geospatial libraries and applications."
  homepage "https://trac.osgeo.org/ossim/wiki"
  url "http://download.osgeo.org/ossim/source/ossim-1.8.20/ossim-1.8.20-1.tar.gz"
  sha256 "a9148cbc7eebaed1d09d139e68c038592edcf74318ec2623f21494aa56879f52"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "open-scene-graph"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libgeotiff"
  depends_on "ffmpeg"
  depends_on "gdal" => :optional
  needs :openmp if build.with? "openmp"

  def install
    args = std_cmake_args
    args += [
      "-DBUILD_OSSIM_FRAMEWORKS=ON",
      "-DBUILD_SHARED_LIBS=ON",
      "-DBUILD_OSSIM_PACKAGES=ON",
      "-DBUILD_OSSIM_TEST_APPS=ON",
    ]

    args += [
      "-DBUILD_OSSIM_PLUGIN=ON",
#      "-DBUILD_OSSIMCSM_PLUGIN=ON",
      "-DBUILD_OSSIMREGISTRATION_PLUGIN=ON",
    ]

    args += [
      "-DBUILD_OSSIMPLANET=OFF",
      "-DBUILD_OSSIMQT4=OFF",
      "-DBUILD_OSSIMGUI=OFF",
    ]

    args << "-DBUILD_OSSIMGDAL_PLUGIN=" + (build.with?("gdal") ? "ON" : "OFF")
    args << "-DBUILD_OSSIMPNG_PLUGIN=" + (build.with?("libpng") ? "ON" : "OFF")

    ossim_dev_home = buildpath
    mkdir "ossim_package_support/cmake/build" do
      ENV["OSSIM_DEV_HOME"] = ossim_dev_home
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    (prefix/"etc").mkpath
    generate_prefs("#{ossim_dev_home}/ossim/etc/templates/ossim_preferences_template", "#{prefix}/etc/ossim_preferences")
  end

  def generate_prefs(template, destination)
    templatedata = File.read(template)

    # use all of the built plugins, by directory
    templatedata = templatedata.gsub(%r{/((\/\/---[^\n]*\n)(\/\/ OSSIM plugin support:\n)(\/\/[^\n]*\n)*(\/\/---[^\n]*\n))/m}, "\\1\nplugin.dir0: $(OSSIM_INSTALL_PREFIX)/lib64/ossim/plugins/\n\n")
    templatedata = templatedata.gsub(/^(plugin.file)/, '// \1')

    File.open(destination, "w") do |w|
      w.write(templatedata)
    end
  end

  test do
    system "#{bin}/ossim-info", "--version"
  end
end
