require 'formula'

class Passenger < Formula
  homepage 'https://www.phusionpassenger.com/'
  url 'http://s3.amazonaws.com/phusion-passenger/releases/passenger-4.0.44.tar.gz'
  sha1 '3938209ff342b9871ef06b9bda1f42995382d3b0'
  head 'https://github.com/phusion/passenger.git'

  bottle do
    sha1 "579aecafb14322ec724f4b75c934426a28799e36" => :mavericks
    sha1 "4d194dca9247ae89217a7f0da3424de30b277206" => :mountain_lion
  end

  depends_on 'pcre'
  depends_on :macos => :mountain_lion

  def install
    rake "apache2"
    rake "nginx"
    rake "webhelper"

    necessary_files = Dir["configure", "Rakefile", "README.md", "CONTRIBUTORS",
      "CONTRIBUTING.md", "LICENSE", "CHANGELOG", "INSTALL.md",
      "passenger.gemspec", "build", "lib", "node_lib", "bin", "doc", "man",
      "helper-scripts", "ext", "resources", "buildout"]
    libexec.mkpath
    cp_r necessary_files, libexec, :preserve => true

    # Allow Homebrew to create symlinks for the Phusion Passenger commands.
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Ensure that the Phusion Passenger commands can always find their library
    # files.
    locations_ini = `/usr/bin/ruby ./bin/passenger-config --make-locations-ini --for-native-packaging-method=homebrew`
    locations_ini.gsub!(/=#{Regexp.escape Dir.pwd}/, "=#{libexec}")
    (libexec/"lib/phusion_passenger/locations.ini").write(locations_ini)
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--ruby", libexec/"lib", *Dir[libexec/"bin/*"]
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec/"bin", libexec/"ext/nginx/config"

    mv libexec/'man', share
  end

  def caveats; <<-EOS.undent
    To activate Phusion Passenger for Apache, create /etc/apache2/other/passenger.conf:
      LoadModule passenger_module #{opt_libexec}/buildout/apache2/mod_passenger.so
      PassengerRoot #{opt_libexec}/lib/phusion_passenger/locations.ini
      PassengerDefaultRuby /usr/bin/ruby

    To activate Phusion Passenger for Nginx, run:
      brew install nginx --with-passenger
    EOS
  end

  test do
    ruby_libdir = `#{HOMEBREW_PREFIX}/bin/passenger-config --ruby-libdir`.strip
    if ruby_libdir != (libexec/"lib").to_s
      raise "Invalid installation"
    end
  end
end
