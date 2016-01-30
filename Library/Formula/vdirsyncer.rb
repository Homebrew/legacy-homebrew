class Vdirsyncer < Formula
  desc "Synchronize calendars and contacts"
  homepage "https://github.com/untitaker/vdirsyncer"
  url "https://pypi.python.org/packages/source/v/vdirsyncer/vdirsyncer-0.8.1.tar.gz"
  sha256 "e8602a5df862124351dec92515019b2875616cc90c15499b681d8c6e38a66ea9"
  head "https://github.com/untitaker/vdirsyncer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c3c344568bb705b53f2f3ab99d6ad8d91bc485c23b9e3e9f8d82c2a342c690a" => :el_capitan
    sha256 "70a109a6fa25846807b12d67f213da5359b94304b149c5671a782c3e38574629" => :yosemite
    sha256 "2f4267ddbfb7a48cac0155aa6de00e93bcbf485e2c957911bb77c6d845b69a58" => :mavericks
  end

  option "with-remotestorage", "Build with support for remote-storage"

  depends_on :python3

  resource "requests_oauthlib" do
    url "https://pypi.python.org/packages/source/r/requests-oauthlib/requests-oauthlib-0.6.0.tar.gz"
    sha256 "2a0ca56031940e917983aa1584b9d1311769ff9fc9bbf01e06c7f75ade7c7724"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "click_threading" do
    url "https://pypi.python.org/packages/source/c/click-threading/click-threading-0.1.2.tar.gz"
    sha256 "85045457e02f16fba3110dc6b16e980bf3e65433808da2b550dd513206d9b94a"
  end

  resource "click_log" do
    url "https://pypi.python.org/packages/source/c/click-log/click-log-0.1.1.tar.gz"
    sha256 "0bc7e69311007adc4b5304d47933761999a43a18a87b9b7f2aa12b5e256f72fc"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "requests-toolbelt" do
    url "https://pypi.python.org/packages/source/r/requests-toolbelt/requests-toolbelt-0.5.1.tar.gz"
    sha256 "4f4be5325cf4af12847252406eefca8e9d1cd3cfb23a377aaac5cea32d55d23e"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.4.4.tar.gz"
    sha256 "b3d362bac471172747cda3513238f115cbd6c5f8b8e6319bf6a97a7892724099"
  end

  resource "atomicwrites" do
    url "https://pypi.python.org/packages/source/a/atomicwrites/atomicwrites-0.1.5.tar.gz"
    sha256 "9b16a8f1d366fb550f3d5a5ed4587022735f139a4187735466f34cf4577e4eaa"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"
    rs = %w[click click_threading click_log requests lxml requests-toolbelt atomicwrites]
    rs << "requests_oauthlib" if build.with? "remotestorage"
    rs.each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/".config/vdirsyncer/config").write <<-EOS.undent
      [general]
      status_path = #{testpath}/.vdirsyncer/status/
      [pair contacts]
      a = contacts_a
      b = contacts_b
      collections = ["from a"]
      [storage contacts_a]
      type = filesystem
      path = ~/.contacts/a/
      fileext = .vcf
      [storage contacts_b]
      type = filesystem
      path = ~/.contacts/b/
      fileext = .vcf
    EOS
    (testpath/".contacts/a/foo/092a1e3b55.vcf").write <<-EOS.undent
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    (testpath/".contacts/b/foo/").mkpath
    system "#{bin}/vdirsyncer", "sync"
    assert_match /BEGIN:VCARD/, (testpath/".contacts/b/foo/092a1e3b55.vcf").read
  end
end
