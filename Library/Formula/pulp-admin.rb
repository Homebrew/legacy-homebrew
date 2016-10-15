require "formula"

class PulpAdmin < Formula
  homepage "http://www.pulpproject.org/"
  head "https://github.com/pulp/pulp.git"
  url "https://github.com/pulp/pulp/archive/pulp-2.4.3-1.tar.gz"
  sha1 "1409fa8a0b449e6c8c12c293b0aa437f54acffbc"

  depends_on "swig" => :build

  resource "okaara" do
    url "https://pypi.python.org/packages/source/o/okaara/okaara-1.0.33.tar.gz"
    sha1 "8d84bec505d9ddc2f4ab68c3ea04f4fd42a7d5b7"
  end

  resource "M2Crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.22.3.tar.gz"
    sha1 "c5e39d928aff7a47e6d82624210a7a31b8220a50"
  end

  resource "iniparse" do
    url "https://pypi.python.org/packages/source/i/iniparse/iniparse-0.4.tar.gz"
    sha1 "2b2af8a19f3e5c212c27d7c524cd748fa0b38650"
  end

  resource "isodate" do
    url "https://pypi.python.org/packages/source/i/isodate/isodate-0.5.0.tar.gz"
    sha1 "1174aeb482567df02933bdc6f6e7c2a9a72eb31e"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"

    res = %w[okaara M2Crypto iniparse isodate]
    res.each do |r|
      resource(r).stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }
    end

    inreplace "client_admin/pulp/client/admin/__init__.py" do |s|
      s.gsub! "/etc/pulp", etc+"pulp"
    end

    client_libs = ["common","bindings","client_lib","client_admin"]
    client_libs.each do |cl|
      cd cl do
        system "python", "setup.py", "install", "--prefix=#{libexec}"
      end
    end

    inreplace "client_admin/etc/pulp/admin/admin.conf" do |s|
      s.gsub! "/usr/lib/pulp/admin/extensions", etc+"pulp/admin/extensions"
    end
    mkdir "client_admin/etc/pulp/admin/extensions"
    mkdir "client_admin/etc/pulp/admin/conf.d"

    etc.install "client_admin/etc/pulp" unless File.directory?(etc+"pulp")

    bin.install libexec+"bin/pulp-admin"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/pulp-admin", "logout"
  end
end
